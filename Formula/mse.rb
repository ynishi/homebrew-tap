class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.32.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.32.1/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2f85a7da02f499930c4a4c742234fc1a5e70a205938c2059bc6a1fa721c494dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.32.1/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8cf3bb0bb73e40d4ac9b96fe646ba2a17134b94bec785c9468f228a5f57fc9f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.32.1/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a938d0d50f66d193ea2da958921adfc6d1806e01964e4ab8cc64ad76069dfa4c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.32.1/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9dd08d61b16d3c14acff7bf9f0678e12ac4e66d1579e330d867faa3247363d94"
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
