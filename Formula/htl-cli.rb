class HtlCli < Formula
  desc "htl command line (also `cargo htl`): check / run / test / fmt / build / pkg / new for Teal projects"
  homepage "https://github.com/ynishi/htl"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.6.1/htl-cli-aarch64-apple-darwin.tar.xz"
      sha256 "951ae4693bd2731a5a7790b72712dd40ee2ef90993e91f26507af77ea9b30b09"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.6.1/htl-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8fd7b73d80f4193693c8614f5643dfd9346dbb5deb5908f530c069f6adf53ebb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.6.1/htl-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "585b28f852cd7074fc274ae9c2d81c78a9df9bbb5145a1bea8f34f41bab289d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.6.1/htl-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4870f96bd8d367660c856687f5c5ff62f6fe4a741053af706d8a43040ed26795"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cargo-htl", "htl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cargo-htl", "htl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cargo-htl", "htl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cargo-htl", "htl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
