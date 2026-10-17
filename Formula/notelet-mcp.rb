class NoteletMcp < Formula
  desc "Thin hosted Markdown note store for coding agents over MCP: Postgres, bearer auth, optimistic locking"
  homepage "https://github.com/ynishi/notelet"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.4.0/notelet-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "0fce97800f9a187d162b609b1b5f57cf7d6f12b7b1573267e863b6a1f5b6977b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.4.0/notelet-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "e0b9e4e74743af69babd8ee67cb3683d970565a2236f9a7beabe819e07c2042a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.4.0/notelet-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "efcee960a722c5fe03776ae6dfca2f1762964fd2dcc53d1fea1fc91a6c7c4807"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.4.0/notelet-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eaf8258e960d241e174aaf3bf5167815c7252d08679ebeb28c440f61ad41537c"
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
