class Alexscript < Formula
  desc "Programming language with Polish syntax"
  homepage "https://github.com/N3BCKN/alexscript"
  url "https://github.com/N3BCKN/alexscript/archive/refs/tags/v0.9.19.tar.gz"
  sha256 "53e9d0b229cfbd9cdd7f3e61b85ae8021d30462feb2313568d3228b62bbb8771"
  license "MIT"
  version "0.9.19"

  depends_on "ruby"

  def install
    libexec.install Dir["lib/*"]
    libexec.install Dir["bin/*"]

    (bin/"alexscript").write <<~EOS
      #!/bin/bash
      export ALEXSCRIPT_USER_PWD="$PWD"
      exec ruby "#{libexec}/bin/alexscript.rb" "$@"
    EOS

    chmod 0755, bin/"alexscript"
  end

  test do
    output = shell_output("echo 'pokazl \"test\"' | #{bin}/alexscript")
    assert_match "test", output
  end
end