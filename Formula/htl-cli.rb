class HtlCli < Formula
  desc "htl command line (also `cargo htl`): check / run / test / fmt / build / pkg / new for Teal projects"
  homepage "https://github.com/ynishi/htl"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.15.0/htl-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f87f87f2da9070e8185be44d27220a75d7bd7fd92ea8a1fe86b8d662945973a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.15.0/htl-cli-x86_64-apple-darwin.tar.xz"
      sha256 "fb35a03a51c51bf49a43626d44f2fddce0fc68a705ca66fba4eea504ef2a2680"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.15.0/htl-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42c20d5bb9a94c98a288949458dc1a91a6e34bf894197ccc119b542d1ba89202"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.15.0/htl-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "38ea7b0dba2d16a8e93646d607b765af024136a4371e9028e4b2d611274699eb"
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
