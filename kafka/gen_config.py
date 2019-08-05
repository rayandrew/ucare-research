import os
import argparse
import mmap

from jproperties import Properties


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='[Kafka] - Config Creator')

    parser.add_argument('--config_template', '-ct', default='./source/config/server.properties',
                        type=str, help='Kafka Server Template')
    parser.add_argument('--server_count', '-n', default=5,
                        type=int, help='Kafka Number of Server')
    parser.add_argument('--logs_dir', '-cd',
                        default='/tmp/kafka-logs', help='hbase logs dir')
    args = parser.parse_args()

    p = Properties(process_escapes_in_values=False)

    p.load(open(args.config_template, 'rb'), 'utf-8')

    for i in range(0, args.server_count):
        # p['broker.id'] = str(int(p['broker.id'].data) + 1)
        p['broker.id'] = str(i)
        # p['port'] = str(9092 + i)
        p['log.dirs'] = '{}/{}'.format('/tmp/kafka-logs', i)
        p['zookeeper.connect'] = 'localhost:2181'
        p['listeners'] = 'PLAINTEXT://:{}'.format(9092 + i)
        p['delete.topic.enable'] = 'true'

        with open('./configs/server-{}.properties'.format(i), 'wb') as f:
            p.store(f, strip_meta=False)
            f.close()
