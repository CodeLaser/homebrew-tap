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
    (bin/"maddi").write_env_script libexec/"bin/maddi", Language::Java.java_home_env("25")
  end

  test do
    assert_match "usage:", shell_output("#{bin}/maddi --help")
  end
end
