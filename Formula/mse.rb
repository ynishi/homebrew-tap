class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.16.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.16.0/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "db586d914cf02a7ca7020d228a3e5d5c047831e1837490be9bed1659a83dafa6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.16.0/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c98eabf5c6df33234e019303b48147af0a7ab2cb84cc42dcfefc77c15b8d7218"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.16.0/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "40e5f648cb34423485e51164f91f724c994030abbd0603227594505a0efb2985"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.16.0/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6da58d699447354ba2754f41a7d774dfd1bbf0ab3b8c3f7d812221ed664da3c2"
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
