class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.12.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.12.1/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c0508f74d5497f03b2e5f0d17809c32ae99b4990503a3b63e0a61dbdcf134b33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.12.1/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a408a4b9054cb10232c51008c0e9ee850e17c62d5febd3907573f682bd1c185a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.12.1/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b5d67a85b544ec4041291fb99743796d58fa9190e5dac05a96d82105fc5707d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.12.1/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d8e236cbcd87835b78b911152483af6446a7d77fc97005a486da9881c07783a2"
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
