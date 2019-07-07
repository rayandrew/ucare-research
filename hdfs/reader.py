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
        description='[HDFS] - Memory Reader')

    parser.add_argument('--node_count', '-nc', default=5,
                        type=int, help='HDFS Node Count')
    parser.add_argument('--cluster_name', '-cn',
                        default='hsgucare-datanode-node-0.j8gc.ucare.emulab.net', help='cluster name')
    parser.add_argument('--logs_dir', '-cd',
                        default='/mnt/extra/ucare-research/hdfs/source/hadoop-dist/target/hadoop-2.7.1/logs/', help='hdfs logs dir')
    args = parser.parse_args()

    mems = []

    # master
    line = _read_logs_2(os.path.join(
        args.logs_dir, 'hadoop-{}.log'.format(args.cluster_name)))

    # slaves
    for i in range(1, args.node_count + 1):
        line = _read_logs_2(os.path.join(
            args.logs_dir, 'slaves-{}'.format(i), 'logs', 'hadoop-{}.log'.format(args.cluster_name)))
        if line is not None:
            digs = [int(s) for s in line.split(' ') if s.isdigit()]
            mems.append(digs[0])

    assert len(mems) == args.node_count + 1, 'All nodes are not up yet'

    print('List of mem used ', mems)
    print('Total memory used for {} is {} MB'.format(args.node_count, sum(mems)))
