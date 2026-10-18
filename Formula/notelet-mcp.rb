class NoteletMcp < Formula
  desc "Thin hosted Markdown note store for coding agents over MCP: Postgres, bearer auth, optimistic locking"
  homepage "https://github.com/ynishi/notelet"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.6.0/notelet-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "e75907fda55236b013390113892f47b042c2c21586a9425e91a6da1ea7866f0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.6.0/notelet-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "83fc3eb1afdcb4d38b3d7aa00febe48674bdcd4a04bf5033e9a137e5f6d66656"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.6.0/notelet-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc4d69a7dfad768732a380762e54c00af0c260f79cb2b1554cc5910004a975d3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.6.0/notelet-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d85a2c85f319040720386c7e4f01069013136f4f7169fcd56ca52d690aced6dd"
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
      bin.install "notelet-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "notelet-mcp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "notelet-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "notelet-mcp"
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
