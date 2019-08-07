import io.github.cdimascio.dotenv.Dotenv;

import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.Host;
import com.datastax.driver.core.Session;

import com.datastax.driver.core.BatchStatement;
import com.datastax.driver.core.BoundStatement;
import com.datastax.driver.core.PreparedStatement;
import com.datastax.driver.core.Statement;
import com.datastax.driver.core.querybuilder.QueryBuilder;
import com.datastax.driver.core.ResultSet;
import com.datastax.driver.core.Row;

import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.UUID;

public class App {
  static private Dotenv dotenv = Dotenv.load();
  static private String keyspace = "test";
  static private String table = "users";

  static private Cluster cluster = null;
  static private Session session = null;

  public Session connect() {
    String[] hosts = dotenv.get("CASSANDRA_NODES").replace("\"", "").split(",");
    System.out.println("Trying to connect to : " + Arrays.toString(hosts));

    if (session == null) {
      cluster = Cluster.builder().addContactPoints(hosts).withLoadBalancingPolicy(new SingleNodePolicy()).build();

      System.out.println("Connected to these host(s) : ");
      for (Host host : cluster.getMetadata().getAllHosts()) {
        System.out.printf("Address: %s, Rack: %s, Datacenter: %s \n", host.getAddress(), host.getDatacenter(),
            host.getRack());
      }

      cluster.init();
      return cluster.connect(keyspace);
    } else {
      return session;
    }
  }

  public void hardCodedInsert(Session session) {
    session.execute("INSERT INTO " + table
        + " ( user_id, created_date, email, first_name, last_name) VALUES (14c532ac-f5ae-479a-9d0a-36604732e01d, '2015-07-22 00:00:00', 'tim.berglund@datastax.com', 'Tim', 'Berglund')");
  }

  public Statement preparedInsert(Session session, String email, String firstName, String lastName) {
    PreparedStatement smt = session
        .prepare(
            "INSERT INTO " + table + " (user_id, created_date, email, first_name, last_name) VALUES (?, ?, ?, ?, ?)")
        .enableTracing();

    BoundStatement bound = new BoundStatement(smt);
    BoundStatement bs = bound.bind(UUID.randomUUID(), new Date(), email, firstName, lastName);

    return bs;
  }

  public Statement selectAllUsers(Session session) {
    return QueryBuilder.select().all().from(keyspace, table);
  }

  public static void main(String args[]) {
    App app = new App();

    Session session = app.connect();

    BatchStatement batchInsert = new BatchStatement();

    for (int i = 0; i <= 400; i++) {
      batchInsert.add(app.preparedInsert(session, "raydreww" + i + "@gmail.com", "Ray", "Andrew"));
    }

    ResultSet resultInsertFirst = session.execute(batchInsert);

    batchInsert.clear();

    for (int i = 0; i <= 400; i++) {
      batchInsert.add(app.preparedInsert(session, "raydreww" + i + "@gmail.com", "Ray", "Andrew"));
    }

    ResultSet resultInsertSecond = session.execute(batchInsert);

    batchInsert.clear();

    for (int i = 0; i <= 400; i++) {
      batchInsert.add(app.preparedInsert(session, "raydreww" + i + "@gmail.com", "Ray", "Andrew"));
    }

    ResultSet resultInsertThird = session.execute(batchInsert);

    batchInsert.clear();

    for (int i = 0; i <= 400; i++) {
      batchInsert.add(app.preparedInsert(session, "raydreww" + i + "@gmail.com", "Ray", "Andrew"));
    }

    ResultSet resultInsertFourth = session.execute(batchInsert);

    System.out.println("Insert first tried host : " + resultInsertFirst.getExecutionInfo().getTriedHosts());
    System.out.println("Insert second tried host : " + resultInsertSecond.getExecutionInfo().getTriedHosts());
    System.out.println("Insert third tried host : " + resultInsertThird.getExecutionInfo().getTriedHosts());
    System.out.println("Insert fourth tried host : " + resultInsertFourth.getExecutionInfo().getTriedHosts());

    System.out.println("Time to do stress testing");

    for (int i = 0; i <= 1000; i++) {
      System.out.println("Request no " + i);

      ResultSet resultSelect = session.execute(app.selectAllUsers(session));
      ResultSet resultSelectSecond = session.execute(app.selectAllUsers(session));
      ResultSet resultSelectThird = session.execute(app.selectAllUsers(session));

      // int countRow = 0;

      // Iterator<Row> resultIterator = resultSelect.iterator();
      // while (resultSelect.iterator().hasNext()) {
      // countRow++;
      // resultIterator.next();
      // System.out.printf("%s %s %s %s\n", row.getUUID("user_id"),
      // row.getString("email"), row.getString("first_name"),
      // row.getString("last_name"));
      // }

      System.out.println("Select First tried host  : " + resultSelect.getExecutionInfo().getQueriedHost());
      System.out.println("Select Second tried host : " + resultSelectSecond.getExecutionInfo().getQueriedHost());
      System.out.println("Select Third tried host  : " + resultSelectThird.getExecutionInfo().getQueriedHost());

      // System.out.println("Row inserted : " + countRow);
    }

    session.close();
    cluster.close();
  }
}