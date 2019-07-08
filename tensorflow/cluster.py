import tensorflow as tf
import sys

grpc_number = int(sys.argv[1])
task_number = int(sys.argv[2])


cluster = tf.train.ClusterSpec(
    {"local": ["localhost:200{}".format(i) for i in range(grpc_number)]})

server = tf.train.Server(cluster, job_name="local", task_index=task_number)

print("Starting server #{}".format(task_number))

server.start()
server.join()
