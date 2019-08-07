import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.Host;
import com.datastax.driver.core.HostDistance;
import com.datastax.driver.core.Statement;
import com.datastax.driver.core.policies.LoadBalancingPolicy;

import com.google.common.collect.AbstractIterator;

import java.net.InetAddress;
import java.util.Collection;
import java.util.Iterator;

/**
 * A single disabler load balancing policy.
 *
 * <p>
 * This policy onlu take one node to process all queries. There is no failover,
 * and only use one node to rule them all.
 *
 * <p>
 * This policy is not datacenter aware and will only pick first contact point of
 * every known Cassandra hosts.
 */
public class SingleNodePolicy implements LoadBalancingPolicy {
  private volatile Host singleHost;
  private volatile InetAddress singleHostAddress;

  /**
   * "Disable" a load balancing policy that only pick one host to query out of all
   * the hosts in the Cassandra cluster.
   */
  public SingleNodePolicy() {
  }

  /**
   * Initializing the single host needed to process the query plan
   *
   * <p>
   * Only get first host so if there are so many host that act as contact points,
   * only first host that will be used
   *
   * @param cluster the cluster that initialize in the driver
   * @param hosts   list of hosts that act as a contact point
   */
  @Override
  public void init(Cluster cluster, Collection<Host> hosts) {
    Iterator<Host> hostsIterator = hosts.iterator();
    if (hostsIterator.hasNext()) {
      singleHost = hostsIterator.next();
      singleHostAddress = singleHost.getAddress();
    } else {
      singleHost = null;
      singleHostAddress = null;
    }
  }

  /**
   * Return the HostDistance for the provided host.
   *
   * <p>
   * This policy consider only single node, which is LOCAL. So set the distance
   * into LOCAL
   *
   * @param host the host of which to return the distance of.
   * @return the HostDistance to {@code host}.
   */
  @Override
  public HostDistance distance(Host host) {
    return HostDistance.LOCAL;
  }

  /**
   * Returns the one "coordinator" host to use for a new query.
   *
   * <p>
   * The returned plan will try only one host of the cluster. Each call of query
   * will be processed into one "coordinator" / "proxy" host
   *
   * @param loggedKeyspace the keyspace currently logged in on for this query.
   * @param statement      the query for which to build the plan.
   * @return an existing query plan, iterator will only consists of single host
   */
  @Override
  public Iterator<Host> newQueryPlan(String loggedKeyspace, Statement statement) {
    return new AbstractIterator<Host>() {
      @Override
      protected Host computeNext() {
        return singleHost == null ? endOfData() : singleHost;
      }
    };
  }

  @Override
  public void onUp(Host host) {
    if (host.getAddress().getHostAddress().equals(singleHostAddress.getHostAddress())) {
      singleHost = host;
    }
  }

  @Override
  public void onDown(Host host) {
    if (host.getAddress().getHostAddress().equals(singleHostAddress.getHostAddress())) {
      singleHost = null;
    }
  }

  @Override
  public void onAdd(Host host) {
    onUp(host);
  }

  @Override
  public void onRemove(Host host) {
    onDown(host);
  }

  @Override
  public void close() {
    // nothing to do
  }
}