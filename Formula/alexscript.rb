class Alexscript < Formula
  desc "Programming language with Polish syntax"
  homepage "https://github.com/N3BCKN/alexscript"
  url "https://github.com/N3BCKN/alexscript/archive/refs/tags/v0.9.19.tar.gz"
  sha256 "48272b5454384f086d0db02257125f37ec31157da8924be0af68a3022eb538ba"
  license "MIT"
  version "0.9.19"

  depends_on "ruby"

  def install
    libexec.install "lib", "bin"

    (bin/"alexscript").write <<~EOS
      #!/bin/bash
      export ALEXSCRIPT_USER_PWD="$PWD"
      exec ruby "#{libexec}/bin/alexscript.rb" "$@"
    EOS

    chmod 0755, bin/"alexscript"
  end

  test do
    output = shell_output("echo 'pokazl \"test\"' | #{bin}/alexscript /dev/stdin")
    assert_match "test", output
  end
end