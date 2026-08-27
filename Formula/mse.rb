class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.27.0/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f519aa4d72ed596f2f5da3a319b74f22112d26c51fb8b28c1563126a605031f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.27.0/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5edf5edf4b857484ff255bf7722f1c44ec1845cfaae785a30e0843f1e2888872"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.27.0/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "971f7ec0ec4874cb245ea03b0869ff50b5b2da898b65cc2b83d5334f36d0ec50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.27.0/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2a6a0e695d8eb31e3ec96ede415e52fae542d27f953b58338d2d6967f4bf7ea"
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
