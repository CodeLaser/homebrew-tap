# The maddi MCP server: a coding agent configures a project, analyses it and asks about the verdicts. It carries
# the maddi IDE daemon in daemon/, which it starts on its own JDK. release-cli.sh in CodeLaser/maddi-dist updates
# url and sha256 at every release.
class MaddiMcp < Formula
  desc "MCP server for maddi, the modification and immutability analyzer for Java"
  homepage "https://github.com/CodeLaser/maddi-dist#coding-agents-mcp"
  url "https://github.com/CodeLaser/maddi/releases/download/v0.9.6/maddi-mcp-0.9.6.zip"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "Apache-2.0"

  depends_on "openjdk@25"

  def install
    rm Dir["bin/*.bat", "daemon/bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"maddi-mcp").write_env_script libexec/"bin/maddi-mcp", Language::Java.java_home_env("25")
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
