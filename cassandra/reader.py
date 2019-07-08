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
        description='[Cassandra] - Memory Reader')

    parser.add_argument('--node_count', '-nc', default=5, type=int, help='Cassandra Node Count')
    parser.add_argument('--cluster_name', '-cn', default='test', help='cluster name')
    parser.add_argument('--conf_dir', '-cd', default='/mnt/extra/working', help='ccm conf dir')
    args = parser.parse_args()


    mems = []
    for i in range(args.node_count):
        line = _read_logs_2(os.path.join(args.conf_dir, args.cluster_name, 'node{}'.format(i + 1), 'logs', 'system.log'))
        if line is not None:
            digs = [int(s) for s in line.split(' ') if s.isdigit()]
            mems.append(digs[0])

    assert len(mems) == args.node_count, 'All nodes are not up yet'

    print('List of mem used ', mems)
    print('Total memory used for {} is {} MB'.format(args.node_count, sum(mems)))