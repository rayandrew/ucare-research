import os
import argparse
import mmap


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
        # nextline = m.readline()
        return str(line)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='[Kafka] - Memory Reader')

    parser.add_argument('--server_node', '-n', default=5,
                        type=int, help='Kafka Server Count')
    parser.add_argument('--logs_dir', '-cd',
                        default='/tmp/kafka-logs/', help='hdfs logs dir')
    args = parser.parse_args()

    servers = []

    # slaves
    for i in range(0, args.server_node):
        line = _read_logs_2(os.path.join(
            args.logs_dir, str(i), 'server.log'))
        if line is not None:
            digs = [int(s) for s in line.split(' ') if s.isdigit()]
            servers.append(digs[0])

    assert len(servers) == args.server_node, 'All nodes are not up yet'

    print('List of dn servers used ', servers)
    print('Total memory used for {} nodes is {} MB'.format(
        args.server_node, sum(servers)))
