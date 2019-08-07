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
        description='[HBase] - Memory Reader')

    parser.add_argument('--additional_region_server', '-ars', default=4,
                        type=int, help='HBase Region Server')
    parser.add_argument('--master_name', '-mn',
                        default='hsgucare-master-node-0.j8gc.ucare.emulab.net', help='cluster name')
    parser.add_argument('--region_server_name', '-rsn',
                        default='hsgucare-{}-regionserver-node-0.j8gc.ucare.emulab.net', help='cluster name')
    parser.add_argument('--logs_dir', '-cd',
                        default='/mnt/extra/ucare-research/memory-tracking/memory-trackinghbase/source/hbase-home/hbase-1.0.4-SNAPSHOT/logs', help='hbase logs dir')
    args = parser.parse_args()

    master_mems = 0
    rs_mems = []

    # master
    line = _read_logs_2(os.path.join(
        args.logs_dir, 'hbase-{}.log'.format(args.master_name)))

    if line is not None:
        digs = [int(s) for s in line.split(' ') if s.isdigit()]
        master_mems = digs[0]

    # region servers
    for i in range(1, args.additional_region_server + 1):
        line = _read_logs_2(os.path.join(
            args.logs_dir, 'hbase-{}.log'.format(args.region_server_name.format(i))))
        if line is not None:
            digs = [int(s) for s in line.split(' ') if s.isdigit()]
            rs_mems.append(digs[0])

    assert len(
        rs_mems) == args.additional_region_server, 'All nodes are not up yet'

    sum_of_rs = sum(rs_mems)

    print('Master used ', master_mems)
    print('List of region server mems used ', rs_mems)
    print('Region server mems used ', sum_of_rs)
    print('Total memory used for {} is {} MB'.format(
        args.additional_region_server, sum_of_rs + master_mems))
