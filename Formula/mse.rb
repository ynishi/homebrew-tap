class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.12.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.12.2/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b0d70b302d7f9cc7ff504d26c661671f861521d9d827f2f6e09a0167f5f52c37"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.12.2/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "db29b7f78f15f649b6fc82f612269ac550362e0fadf83a84b3ceb0d13dc81e6b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.12.2/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "79f3164d21eb197c1d6b7bf3a0e375097a70943f5143c72bbd1b6918ed44701f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.12.2/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "155290b2ab19a65d7896b14587ed5388a245d56b326864246d10428c73932a42"
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
