# The maddi MCP server: a coding agent configures a project, analyses it and asks about the verdicts. It carries
# the maddi IDE daemon in daemon/, which it starts on its own JDK. release-cli.sh in CodeLaser/maddi-dist updates
# url and sha256 at every release.
class MaddiMcp < Formula
  desc "MCP server for maddi, the modification and immutability analyzer for Java"
  homepage "https://github.com/CodeLaser/maddi-dist#coding-agents-mcp"
  url "https://github.com/CodeLaser/maddi/releases/download/v0.9.6/maddi-mcp-0.9.6.zip"
  sha256 "87b84d02ca72a12f9b92ef654eb196820c7e61c89480103a41094937b34a0155"
  license "Apache-2.0"

  depends_on "openjdk@25"

  def install
    rm Dir["bin/*.bat", "daemon/bin/*.bat"]
    libexec.install Dir["*"]
    # Homebrew's JDK, or the one MADDI_JDK_HOME names: Temurin, say, as long as it is 25 or later
    (bin/"maddi-mcp").write <<~SH
      #!/bin/bash
      if [ -n "${MADDI_JDK_HOME:-}" ]; then
        feature=$(sed -n 's/^JAVA_VERSION="\\([0-9]*\\).*/\\1/p' "$MADDI_JDK_HOME/release" 2>/dev/null)
        if [ -z "$feature" ] || [ "$feature" -lt 25 ]; then
          echo "maddi-mcp: MADDI_JDK_HOME=$MADDI_JDK_HOME is not a JDK 25 or later" >&2
          exit 1
        fi
        export JAVA_HOME="$MADDI_JDK_HOME"
      else
        export JAVA_HOME="#{Language::Java.java_home("25")}"
      fi
      exec "#{libexec}/bin/maddi-mcp" "$@"
    SH
    chmod 0755, bin/"maddi-mcp"
  end

  def caveats
    <<~EOS
      Register the server with your coding agent, for Claude Code:
        claude mcp add maddi -- #{opt_bin}/maddi-mcp
    EOS
  end

  test do
    require "open3"
    initialize = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18",' \
                 '"capabilities":{},"clientInfo":{"name":"brew","version":"0"}}}'
    # closing stdin shuts an MCP server down, so read the reply before closing it
    Open3.popen3(bin/"maddi-mcp", "--store", testpath/"store", "--log", testpath/"daemon.log") do |stdin, stdout, _, wait|
      stdin.puts initialize
      stdin.flush
      reply = stdout.gets
      stdin.close
      assert_match "\"serverInfo\":{\"name\":\"maddi\",\"version\":\"#{version}\"}", reply
      assert_predicate wait.value, :success?
    end
  end
end
