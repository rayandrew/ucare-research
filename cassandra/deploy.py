import os
import argparse
import mmap
import time
import csv

import itertools

from ccmlib.cluster import Cluster
from ccmlib import common, extension, repository
from ccmlib.node import Node, NodeError, TimeoutError


class CustomCluster(Cluster):
    def __update_pids(self, started):
        for node, p, _ in started:
            node._update_pid(p)

    def start(self, no_wait=False, verbose=False, wait_for_binary_proto=True,
              wait_other_notice=True, jvm_args=['-Xms1024M', '-Xmx1024M'], profile_options=None,
              quiet_start=False, allow_root=False, **kwargs):
        # if jvm_args is None:
        #     jvm_args = []

        extension.pre_cluster_start(self)

        common.assert_jdk_valid_for_cassandra_version(self.cassandra_version())

        # check whether all loopback aliases are available before starting any nodes
        for node in list(self.nodes.values()):
            if not node.is_running():
                for itf in node.network_interfaces.values():
                    if itf is not None:
                        common.assert_socket_available(itf)

        started = []
        for node in list(self.nodes.values()):
            if not node.is_running():
                mark = 0
                if os.path.exists(node.logfilename()):
                    mark = node.mark_log()

                p = node.start(update_pid=False, jvm_args=jvm_args, profile_options=profile_options,
                               verbose=verbose, quiet_start=quiet_start, allow_root=allow_root)

                # Prior to JDK8, starting every node at once could lead to a
                # nanotime collision where the RNG that generates a node's tokens
                # gives identical tokens to several nodes. Thus, we stagger
                # the node starts
                # if common.get_jdk_version() < '1.8':

                # [RAYANDREW] modify this
                # print('Waiting 10s before starting other node')
                time.sleep(10)  # wait 10 seconds before starting other node

                started.append((node, p, mark))

        if no_wait:
            # waiting 2 seconds to check for early errors and for the pid to be set
            time.sleep(2)
        else:
            for node, p, mark in started:
                try:
                    start_message = "Listening for thrift clients..." if self.cassandra_version(
                    ) < "2.2" else "Starting listening for CQL clients"
                    node.watch_log_for(start_message, timeout=kwargs.get(
                        'timeout', 60), process=p, verbose=verbose, from_mark=mark)
                except RuntimeError:
                    return None

        self.__update_pids(started)

        for node, p, _ in started:
            if not node.is_running():
                raise NodeError("Error starting {0}.".format(node.name), p)

        if not no_wait:
            if wait_other_notice:
                for (node, _, mark), (other_node, _, _) in itertools.permutations(started, 2):
                    node.watch_log_for_alive(other_node, from_mark=mark)

            if wait_for_binary_proto:
                for node, p, mark in started:
                    node.wait_for_binary_interface(
                        process=p, verbose=verbose, from_mark=mark)

        extension.post_cluster_start(self)

        return started


def _read_logs(filename, text='Used Memory'):
    line = None

    with open(filename, 'r') as f:
        line = next((l for l in f if text in l), None)

    return line


def _read_logs_2(filename, text='Used Memory'):
    with open(filename, 'r') as f:
        # memory-map the file, size 0 means whole file
        m = mmap.mmap(f.fileno(), 0, prot=mmap.PROT_READ)
        # prot argument is *nix only

        i = m.rfind(b'Used Memory')   # search for last occurrence of 'word'
        m.seek(i)             # seek to the location
        line = m.readline()   # read to the end of the line
        return str(line)


def log_parser(args, node_count):
    mems = []

    for i in range(node_count):
        line = _read_logs(os.path.join(
            args.cluster_path, args.cluster_name, 'node{}'.format(i + 1), 'logs', 'system.log'))
        if line is not None:
            mem_digits = [int(s) for s in line.split(' ') if s.isdigit()]
            mems.append(mem_digits[0])
    return mems


def deploy_cluster(args, node_count):
    cluster = CustomCluster(
        path=args.cluster_path,
        name=args.cluster_name,
        install_dir=args.cassandra_dir)
    cluster.populate(node_count).start()

    return cluster


def stop_remove_cluster(cluster):
    cluster.stop()
    cluster.remove()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='[Cassandra] - Memory Reader')

    parser.add_argument('--node_count', '-nc', default=5,
                        type=int, help='Cassandra Node Count')
    parser.add_argument('--cassandra_dir', '-cd',
                        default='/mnt/extra/ucare-research/cassandra/source', help='cassandra source dir')
    parser.add_argument('--cluster_name', '-cn',
                        default='test', help='cluster name')
    parser.add_argument('--cluster_path', '-cp',
                        default='/mnt/extra/working', help='ccm conf dir')
    args = parser.parse_args()

    # result = []

    with open('result.csv', mode='w') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=['nodes', 'mems'])
        writer.writeheader()

        for node_count in range(10, args.node_count + 10, 10):
            print('Starting Cluster consists of {} nodes'.format(node_count))
            cluster = deploy_cluster(args, node_count)

            print('Delay about 1 minute before trying to read memory logs')
            time.sleep(60)

            print('Start reading the logs')

            mems = []

            while True:
                mems = log_parser(args, node_count)
                time.sleep(2)
                if len(mems) == node_count:
                    break

            total_mems = sum(mems)
            print('List of mem used ', mems)
            print('Total memory used for {} nodes is : {} MB'.format(
                node_count, total_mems))

            writer.writerow({'nodes': node_count, 'mems': total_mems})

            print('Stopping and Remove Cluster')
            stop_remove_cluster(cluster)

            print('Delaying 10 secs before spawning another cluster\n')
            time.sleep(10)
