package ray.dedup

import java.util.concurrent._
import java.util.concurrent.atomic.{AtomicBoolean, AtomicInteger}

object App extends Logging {
  val memoryReaderScheduler = Executors.newSingleThreadScheduledExecutor

  var arr: List[String] = List.fill(10485)("Ray Andrew")

  def main(args: Array[String]): Unit = {
    info("Starting program")

    memoryReaderScheduler.schedule(new MemoryReader(), 1, TimeUnit.SECONDS)

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