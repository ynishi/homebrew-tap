class NoteletMcp < Formula
  desc "Thin hosted Markdown note store for coding agents over MCP: Postgres, bearer auth, optimistic locking"
  homepage "https://github.com/ynishi/notelet"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.7.0/notelet-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "5cfe2f3c097ec863be3875fe1f56b5b87cf74221bf41d8a03c1929d0549fcd15"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.7.0/notelet-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "ca0243b626dc0de024f2b4ab6cc9cb9e3fc9e3a75ddd432a76315a93d5d8ca75"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.7.0/notelet-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "50d27560d7cbf99ca2ffdd38e7441eb4945015c9eb48e6f1e9944298f43c2d2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.7.0/notelet-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1ddedab3d7fe9c1461111e4dc2187eb61140f7e5ab6b09d5e4244338f6e9f3a6"
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
