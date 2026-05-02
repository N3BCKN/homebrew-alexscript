class Alexscript < Formula
  desc "Programming language with Polish syntax"
  homepage "https://github.com/N3BCKN/alexscript"
  url "https://github.com/N3BCKN/alexscript/archive/refs/tags/v0.9.21.tar.gz"
  sha256 "b44e375afb0d0b244a905718252e62d53e4b8d9aa08e302dc3be595210697af3"
  license "MIT"
  version "0.9.21"

  depends_on "ruby"

  resource "colorize" do
    url "https://rubygems.org/downloads/colorize-1.1.0.gem"
    sha256 "30b5237f0603f6662ab8d1fc2bd4a96142b806c6415d79e45ef5fdc6a0cfc837"
  end

  resource "slop" do
    url "https://rubygems.org/downloads/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  def install
    gem_bin = Formula["ruby"].opt_bin/"gem"
    ruby_bin = Formula["ruby"].opt_bin/"ruby"

    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system gem_bin, "install", r.cached_download,
             "--no-document",
             "--install-dir", libexec/"gems"
    end

    libexec.install "lib", "bin"

    (bin/"alexscript").write <<~EOS
      #!/bin/bash
      export GEM_HOME="#{libexec}/gems"
      export GEM_PATH="#{libexec}/gems"
      export ALEXSCRIPT_USER_PWD="$PWD"
      exec "#{ruby_bin}" "#{libexec}/bin/alexscript.rb" "$@"
    EOS

    chmod 0755, bin/"alexscript"
  end

  test do
    output = shell_output("echo 'pokazl \"test\"' | #{bin}/alexscript /dev/stdin")
    assert_match "test", output
  end
end