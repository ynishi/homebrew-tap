class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.24.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.24.0/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a331b5f69b854e83edbefbbe485ded2cc1ac1d75535b0a63959da0d6c16c31f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.24.0/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "297ad6a7244625b81809fd855d2046dfe6d7da053546479051df5e5ecf6f6ddc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.24.0/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d780d0df75a175fe56d737fe43903f82681796a7cd023b8416858dc236a1a928"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.24.0/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "127c9576b8bd8e676cf3500885f8135fc66440c90b66d7dd52e26972b4ec87b0"
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
