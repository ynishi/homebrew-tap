class NoteletMcp < Formula
  desc "Thin hosted Markdown note store for coding agents over MCP: Postgres, bearer auth, optimistic locking"
  homepage "https://github.com/ynishi/notelet"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.8.0/notelet-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "804afc6ee287cddadb2463c01bc1be7cab5d0fb5ace404ffc5419609e03652e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.8.0/notelet-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "162a29b7c0755b4611e76e46947eef930075bfade4db593cb092448e15980f9f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/notelet/releases/download/v0.8.0/notelet-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "605121685242d4ace44b4aa86d18ca1576a40e2b4522a4b8ccf9aaa5c042d904"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/notelet/releases/download/v0.8.0/notelet-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "362b87b910e0da038c7c8198c8ade9f4000339107fd8cc7b875c94b7036deac8"
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
