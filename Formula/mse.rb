class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.23.0/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fd4e03fbd978d7510ac9d0b5ad7552603be379c302d99996dff37787b8d10805"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.23.0/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "73283a003968a64309a2254b7d78fcab64d062eaf0b5c3f47b4bd6fcbb3b801f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.23.0/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41d483eedc3a25415d0afe56ef24e62061d6fa4fc3f3d7cc348a0f2d78214b97"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.23.0/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ab04a00078b4cbea1dc6d4baba635c9b0ec0951ddb341a5c0c3a7f58eab52e4"
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
    bin.install "mse" if OS.mac? && Hardware::CPU.arm?
    bin.install "mse" if OS.mac? && Hardware::CPU.intel?
    bin.install "mse" if OS.linux? && Hardware::CPU.arm?
    bin.install "mse" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
