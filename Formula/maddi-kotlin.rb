# The maddi command line for projects with Kotlin sources: maddi's options, with the K2 front end in lib-k2/.
# It needs a JDK 26 or later. release-cli.sh in CodeLaser/maddi-dist updates url and sha256 at every release.
class MaddiKotlin < Formula
  desc "Modification and immutability analyzer for Java and Kotlin"
  homepage "https://github.com/CodeLaser/maddi"
  url "https://github.com/CodeLaser/maddi/releases/download/v0.9.5/maddi-kotlin-0.9.5.zip"
  sha256 "5523b0f73f66b0e6a3f092bb27c346402a14dbadfdc884f07a388dfffdd4db28"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (bin/"maddi-kotlin").write_env_script libexec/"bin/maddi-kotlin", Language::Java.java_home_env
  end

  test do
    assert_match "usage:", shell_output("#{bin}/maddi-kotlin --help")
  end
end
