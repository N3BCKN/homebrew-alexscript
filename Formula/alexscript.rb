class Alexscript < Formula
  desc "Programming language with Polish syntax"
  homepage "https://github.com/N3BCKN/alexscript"
  url "https://github.com/N3BCKN/alexscript/archive/refs/tags/v0.10.28.tar.gz"
  sha256 "1d2a9572678567a73e9995d9aeb65fad0165297fb8e821aba65c0b9492e24d15"
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
    (testpath/"t.as").write('pokazl "test"')
    assert_match "test", shell_output("#{bin}/alexscript #{testpath}/t.as")
  end
end

