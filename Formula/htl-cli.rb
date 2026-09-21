class HtlCli < Formula
  desc "htl command line (also `cargo htl`): check / run / test / fmt / build / pkg / new for Teal projects"
  homepage "https://github.com/ynishi/htl"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.7.0/htl-cli-aarch64-apple-darwin.tar.xz"
      sha256 "622bdc4e7e7b7134ecfb2f878b37441592e6bc25da79025f51dfc6e0a8e5d5f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.7.0/htl-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d4a2afa2a10669c8b32dab064dd562164b234ecbd2843080bed87953fbab1e94"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.7.0/htl-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0dbf89d92f468bd844f13d5ce53fab13aed36c6c7e4cb65b5a6e2f507a6819bc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.7.0/htl-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0f7498f3b6370030fcd34da5b589638870d57f74c1160bea4415f5af9150ffef"
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
