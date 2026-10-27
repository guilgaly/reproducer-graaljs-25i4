package repro;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import org.graalvm.polyglot.Context;
import org.graalvm.polyglot.Value;

public class Main {
  static String readResource(String path) {
    // Search the system class loader and the whole classpath, incl. the JDK's own modules
    try (InputStream in = ClassLoader.getSystemResourceAsStream(path)) {
      return in == null ? "<not found>" : new String(in.readAllBytes(), StandardCharsets.UTF_8).strip();
    } catch (IOException e) {
      return "<error: " + e + ">";
    }
  }

  public static void main(String[] args) {
    System.out.println("graaljs version = " + readResource("META-INF/graalvm/org.graalvm.truffle/version"));
    System.out.println("graal compiler version = " + readResource("META-INF/graalvm/jdk.graal.compiler/version"));
    try (Context context = Context.create("js")) {
      Value result = context.eval("js", "[1, 2, 3].map(x => x * 2).join(',')");
      System.out.println("JS result = " + result.asString());
    }
  }
}
