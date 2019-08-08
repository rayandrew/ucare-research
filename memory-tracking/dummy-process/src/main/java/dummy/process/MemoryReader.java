package dummy.process;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.File;

public class MemoryReader implements Runnable {
    private File file = null;
    private boolean exists = false;

    private static final int MegaBytes = 1024 * 1024;

    private static final Logger logger = LogManager.getLogger(MemoryReader.class);

    public MemoryReader() {

    }

    @Override
    public void run() {
        while (!Thread.currentThread().isInterrupted()) {
            try {

//                file = new File("/mnt/extra/holder.txt");
                file = new File("/Users/rayandrew/.zshrc");
                exists = file.exists();

                System.gc();

                Thread.sleep(5000);

                if (exists) {
                    long freeMemory = Runtime.getRuntime().freeMemory() / MegaBytes;
                    long totalMemory = Runtime.getRuntime().totalMemory() / MegaBytes;
                    long maxMemory = Runtime.getRuntime().maxMemory() / MegaBytes;

                    logger.warn("Used Memory  : {} MB", (totalMemory - freeMemory));
                    logger.warn("Free Memory  : {} MB", (freeMemory));
                    logger.warn("Total memory : {} MB", (totalMemory));
                    logger.warn("Max Memory   : {} MB", (maxMemory));
                } else {
                    logger.warn("Waiting for file exists");
                }
            } catch (InterruptedException e) {
                logger.error("Error while sleeping");
            }
        }
    }

}
