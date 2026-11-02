# The maddi command line for projects with Kotlin sources: maddi's options, with the K2 front end in lib-k2/.
# It needs a JDK 26 or later. release-cli.sh in CodeLaser/maddi-dist updates url and sha256 at every release.
class MaddiKotlin < Formula
  desc "Modification and immutability analyzer for Java and Kotlin"
  homepage "https://github.com/CodeLaser/maddi"
  url "https://github.com/CodeLaser/maddi/releases/download/v0.9.6/maddi-kotlin-0.9.6.zip"
  sha256 "6e8dbe8775a58078166dba92d87cf00d6399297798748d346f1194d65f15b41f"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    # Homebrew's JDK, or the one MADDI_JDK_HOME names: Temurin, say, as long as it is 26 or later
    (bin/"maddi-kotlin").write <<~SH
      #!/bin/bash
      if [ -n "${MADDI_JDK_HOME:-}" ]; then
        feature=$(sed -n 's/^JAVA_VERSION="\\([0-9]*\\).*/\\1/p' "$MADDI_JDK_HOME/release" 2>/dev/null)
        if [ -z "$feature" ] || [ "$feature" -lt 26 ]; then
          echo "maddi-kotlin: MADDI_JDK_HOME=$MADDI_JDK_HOME is not a JDK 26 or later" >&2
          exit 1
        fi
        export JAVA_HOME="$MADDI_JDK_HOME"
      else
        export JAVA_HOME="#{Language::Java.java_home}"
      fi
      exec "#{libexec}/bin/maddi-kotlin" "$@"
    SH
    chmod 0755, bin/"maddi-kotlin"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/maddi-kotlin --help")
  end
end
