import tensorflow as tf
from tensorflow.python.client import timeline


cluster = tf.train.ClusterSpec({"local": ["localhost:2222", "localhost:2223"]})

x = tf.constant(2)

no_opt = tf.compat.v1.OptimizerOptions(opt_level=tf.compat.v1.OptimizerOptions.L0,
                                       do_common_subexpression_elimination=False,
                                       do_function_inlining=False,
                                       do_constant_folding=False)

# config = tf.ConfigProto()
config = tf.compat.v1.ConfigProto(graph_options=tf.GraphOptions(optimizer_options=no_opt),
                                  log_device_placement=True,
                                  allow_soft_placement=False,
                                  # device_count={"CPU": 3},
                                  inter_op_parallelism_threads=1,
                                  intra_op_parallelism_threads=1)
# sess = tf.Session(config=config)


with tf.device("/job:local/task:1"):
    y2 = x - 66

with tf.device("/job:local/task:0"):
    y1 = x + 300
    y = y1 + y2

# with tf.device("cpu:0"):
#     a = tf.ones((13, 1))
# with tf.device("cpu:1"):
#     b = tf.ones((1, 13))
# with tf.device("cpu:2"):
#     c = a+b

with tf.compat.v1.Session("grpc://localhost:2222", config=config) as sess:
    # sess = tf.Session(config=config)
    run_metadata = tf.RunMetadata()
    options = tf.RunOptions(trace_level=tf.RunOptions.FULL_TRACE)
    # sess.run(y, options=tf.RunOptions(trace_level=tf.RunOptions.FULL_TRACE,
    #                                   output_partition_graphs=True), run_metadata=run_metadata)

    # ad = sess.run(tf.contrib.memory_stats.BytesInUse())
    sess.run(y, options=options, run_metadata=run_metadata)

    # Create the Timeline object, and write it to a json file
    fetched_timeline = timeline.Timeline(run_metadata.step_stats)
    chrome_trace = fetched_timeline.generate_chrome_trace_format()
    with open('timeline_01.json', 'w') as f:
        f.write(chrome_trace)

    # with open("./run2.txt", "w") as out:
    #     out.write(str(run_metadata))
        # out.write(str(ad))

# with tf.compat.v1.Session("grpc://localhost:2222") as sess:
#     d = sess.run(tf.contrib.memory_stats.BytesInUse())
#     result = sess.run(y)
#     print(result, d)
