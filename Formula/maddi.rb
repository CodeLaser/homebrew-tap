# The maddi command line: the modification and immutability analyzer for Java, and its translators.
# release-cli.sh in CodeLaser/maddi-dist updates url and sha256 at every release.
class Maddi < Formula
  desc "Modification and immutability analyzer for Java, and Java translator"
  homepage "https://github.com/CodeLaser/maddi"
  url "https://github.com/CodeLaser/maddi/releases/download/v0.9.5/maddi-0.9.5.zip"
  sha256 "97ad0a266644d5cd4e0cd32e283a4141db96ae9ef5381da6bf193ee0ac7269cc"
  license "Apache-2.0"

  depends_on "openjdk@25"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    # Homebrew's JDK, or the one MADDI_JDK_HOME names: Temurin, say, as long as it is 25 or later
    (bin/"maddi").write <<~SH
      #!/bin/bash
      if [ -n "${MADDI_JDK_HOME:-}" ]; then
        feature=$(sed -n 's/^JAVA_VERSION="\\([0-9]*\\).*/\\1/p' "$MADDI_JDK_HOME/release" 2>/dev/null)
        if [ -z "$feature" ] || [ "$feature" -lt 25 ]; then
          echo "maddi: MADDI_JDK_HOME=$MADDI_JDK_HOME is not a JDK 25 or later" >&2
          exit 1
        fi
        export JAVA_HOME="$MADDI_JDK_HOME"
      else
        export JAVA_HOME="#{Language::Java.java_home("25")}"
      fi
      exec "#{libexec}/bin/maddi" "$@"
    SH
    chmod 0755, bin/"maddi"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/maddi --help")
  end
end
