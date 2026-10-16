package utils;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

import config.Config;

/**
 * Suite-level reporting.
 *
 * <p>Writes the outcome of every test to {@code target/suite-report.txt} in
 * addition to the Surefire XML. QA needs one flat file to paste into the Jira
 * ticket, and a second listener in each test class would defeat the purpose of
 * having shared infrastructure.
 */
public class SuiteListener implements ITestListener {

    private static final Path REPORT = Path.of("target", "suite-report.txt");

    /**
     * Guards the one-time header.
     *
     * <p>TestNG calls {@link #onStart} once per test <i>context</i> (i.e. once
     * per class), so without this flag each class would truncate the previous
     * classes' results.
     */
    private static boolean headerWritten;

    @Override
    public void onStart(ITestContext context) {
        if (headerWritten) {
            return;
        }
        headerWritten = true;

        // Truncate, never append. An append-only report silently accumulates
        // the results of every previous run, so a green suite can sit directly
        // beneath forty red lines - and the file stops being evidence of
        // anything.
        try {
            Files.createDirectories(REPORT.getParent());
            Files.writeString(
                    REPORT,
                    "StreetBite Appium suite - "
                            + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                            + " on " + Config.deviceName() + System.lineSeparator(),
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.TRUNCATE_EXISTING);
        } catch (Exception e) {
            System.err.println("Could not start the suite report: " + e.getMessage());
        }
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        record("PASS", result);
    }

    @Override
    public void onTestFailure(ITestResult result) {
        record("FAIL", result);
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        record("SKIP", result);
    }

    @Override
    public void onFinish(ITestContext context) {
        // The report directory may not exist when every test was filtered out.
        try {
            Files.createDirectories(REPORT.getParent());
        } catch (Exception e) {
            // Reporting must never break the run.
        }
    }

    private void record(String status, ITestResult result) {
        String line = String.format(
                "%-5s | %-16s | %s%n",
                status,
                result.getTestClass().getName(),
                result.getMethod().getMethodName());

        try {
            Files.createDirectories(REPORT.getParent());
            Files.writeString(
                    REPORT,
                    line,
                    StandardCharsets.UTF_8,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.APPEND);
            System.out.print(line);
        } catch (Exception e) {
            System.err.println("Could not write the suite report: " + e.getMessage());
        }
    }

    /** Clears the report before a run so results are never appended twice. */
    public static void resetReport() {
        File file = REPORT.toFile();
        if (file.exists() && !file.delete()) {
            System.err.println("Could not delete the previous suite report.");
        }
        headerWritten = false;
    }
}