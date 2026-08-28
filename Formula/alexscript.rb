class Alexscript < Formula
  desc "Programming language with Polish syntax"
  homepage "https://github.com/N3BCKN/alexscript"
  url "https://github.com/N3BCKN/alexscript/archive/refs/tags/v0.10.27.tar.gz"
  sha256 "fe60b86d20c18d87574547097181be5a0e3eac7e2c5a60bcf78431ba7b51da56"
  license "MIT"

  depends_on "ruby"

  resource "reline" do
    url "https://rubygems.org/downloads/reline-0.5.12.gem"
    sha256 "41ab36d3fd2aaa169e99f8b82a93b9585f51130529360e24388fcccc20a055a2"
  end

  resource "colorize" do
    url "https://rubygems.org/downloads/colorize-1.1.0.gem"
    sha256 "30b5237f0603f6662ab8d1fc2bd4a96142b806c6415d79e45ef5fdc6a0cfc837"
  end

  resource "slop" do
    url "https://rubygems.org/downloads/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  resource "csv" do
    url "https://rubygems.org/downloads/csv-3.3.5.gem"
    sha256 "6e5134ac3383ef728b7f02725d9872934f523cb40b961479f69cf3afa6c8e73f"
  end

  resource "readline" do
    url "https://rubygems.org/downloads/readline-0.0.4.gem"
    sha256 "6138eef17be2b98298b672c3ea63bf9cb5158d401324f26e1e84f235879c1d6a"
  end

  resource "net-http" do
    url "https://rubygems.org/downloads/net-http-0.6.0.gem"
    sha256 "9621b20c137898af9d890556848c93603716cab516dc2c89b01a38b894e259fb"
  end

  def install
    gem_bin = formula_opt_bin("ruby")/"gem"
    ruby_bin = formula_opt_bin("ruby")/"ruby"

    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system gem_bin, "install", r.cached_download,
             "--no-document",
             "--ignore-dependencies",
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