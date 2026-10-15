class NoteletMcp < Formula
  desc "Thin hosted Markdown note store for coding agents over MCP: Postgres, bearer auth, optimistic locking"
  homepage "https://github.com/ynishi/notelet"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.3.0/notelet-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "828692150ffd5c5bf1fa4349b5e897892b2e70a577ebee8bbf90ac7eb1f6db57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.3.0/notelet-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "b9a1b5b070295f65fecae0c7110d74969f358875b37adaa800c14c6d2ee028d6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.3.0/notelet-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d2d4804894acfb7e1e86ef752e00a129592ce034fcc411d2f61f8ac1ee5f5c59"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.3.0/notelet-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "657d7eac41c1cefa11c9e6f1deaa5180d1e67ca83077f6baa0809123840b14e6"
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
