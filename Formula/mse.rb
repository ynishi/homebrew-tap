class Mse < Formula
  desc "Command line interface for mlua-swarm (mse binary with serve / mcp subcommands)."
  homepage "https://github.com/ynishi/mlua-swarm"
  version "0.29.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.29.0/mlua-swarm-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4581e19a4d1195b5a395ea20a544824133f2378443d0813e20d8cc96eb05a0ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.29.0/mlua-swarm-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2f7abb37fce3b4f9ddc32710dd638eb07427c360cea0224aa41e6a098380ac8f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.29.0/mlua-swarm-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7056428edbf7ae0e8af7c27b2ba16252d05802f26181d07aa017e24641fbd9bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/mlua-swarm/releases/download/v0.29.0/mlua-swarm-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cc01976f5f871dd6f36a9b650cf00749cc9c289876fa6cfcbf90217b4f71fd59"
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
