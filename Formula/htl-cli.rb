class HtlCli < Formula
  desc "htl command line (also `cargo htl`): check / run / test / fmt / build / pkg / new for Teal projects"
  homepage "https://github.com/ynishi/htl"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.16.0/htl-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0f10aa63dae7aefe26df6de71a27b0dbe7a6acb5e785f8a9beac61adc57ade46"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.16.0/htl-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3dba72e7dcd8e5a0a3c49939872df92b3ed1fe7a2acc31a472542751d710bbba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.16.0/htl-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "04778d4b4588507e6795f9229ef7a3e14f0d7cc305086c9e642080bcaaa1360e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.16.0/htl-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f28790246459cc34d1d387eedbc5c43db10bece85192fd148496516a0246c6db"
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
