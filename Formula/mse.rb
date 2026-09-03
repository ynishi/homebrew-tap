class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.28.0/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e8df29324f24f56cfb95990af6badfafc4ade47d0d2b0ae755e28cfaeb260694"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.28.0/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d85e897457498d87bdb3affac78aa64dc9f97e60a8c528d27aae9d9b5f59c694"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.28.0/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3c1adf4ee62f5e4ababfe3624f3ba431d9c3d70b6e659a241a971cfeaab193ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.28.0/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "70e047b6ee04ba55d616f7dabaab6da63275ecd289c16fddf19f52967ad6a0d7"
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
