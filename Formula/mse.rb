class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.32.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.32.0/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ee2d439c0e6b756f86b0015880924ebc842fd8e58ea43c051ca56d31f1a66a7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.32.0/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4ba620a68e148338c319bbd4d5f944d741585042083530e87e7441d06fce5799"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.32.0/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4af559358bfcc30cd06488f336a78c2e5d7dc90802318c220fc1020d138a2aba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.32.0/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e7dc3da5480e302aadd69bd62f5e7ad7e93c8ee8f154a0c3ae36f5973264f20"
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
      bin.install "mse"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mse"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mse"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mse"
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
