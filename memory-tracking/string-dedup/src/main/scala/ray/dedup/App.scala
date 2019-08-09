package ray.dedup

import java.util.concurrent._
import java.util.concurrent.atomic.{AtomicBoolean, AtomicInteger}

import scala.collection.mutable.ListBuffer

object App extends Logging {
  val memoryReaderScheduler = Executors.newSingleThreadScheduledExecutor

  var str = new ListBuffer[String]()

  def main(args: Array[String]): Unit = {
    info("Starting program")

    memoryReaderScheduler.schedule(new MemoryReader(), 1, TimeUnit.SECONDS)

    info("Initiate string buffer")

    for (i <- 1 to 1000) {
      for (j <- 1 to 2000) {
        str += "Hello World-" +  i
      }
    }

    info("String buffer has been successfully built")

    while (true) {
      Thread.sleep(100);
    }

    // attach shutdown handler to catch terminating signals as well as normal termination
    Runtime.getRuntime().addShutdownHook(new Thread("ray-dedup-shutdown-hook") {
      override def run(): Unit = {
        if (memoryReaderScheduler != null) memoryReaderScheduler.shutdown()
        info("Shutting down program")
      }
    })
  }
}