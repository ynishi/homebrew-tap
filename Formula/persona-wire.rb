class PersonaWire < Formula
  desc "persona-wire unified CLI — clap-based bin dispatching subcommands (init / node / edge / spec / projection / wire-init / wire-close / mcp). The `mcp` subcommand boots the stdio MCP server (persona-wire-mcp lib)."
  homepage "https://github.com/ynishi/persona-wire"
  version "0.14.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.1/persona-wire-aarch64-apple-darwin.tar.xz"
      sha256 "525bbba9d51e031f5ecaa162d62ab301c493d503509d7a66213c97f56f98a4a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.1/persona-wire-x86_64-apple-darwin.tar.xz"
      sha256 "3d8512183054b0da96cd1dcefb2740a529ed3521a2d4fda85693ac6c9dc3046c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.1/persona-wire-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "839df6f2e1361af283f84d933fb4c0e28218d802d4e0fcf24d2fdf9fb969f312"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.1/persona-wire-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69439a3933607e512d760be6c5317642a91b62c619e72fc6683d6f530bd7e751"
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
    bin.install "migrate_id_to_ulid", "persona-wire", "pw-migrate" if OS.mac? && Hardware::CPU.arm?
    bin.install "migrate_id_to_ulid", "persona-wire", "pw-migrate" if OS.mac? && Hardware::CPU.intel?
    bin.install "migrate_id_to_ulid", "persona-wire", "pw-migrate" if OS.linux? && Hardware::CPU.arm?
    bin.install "migrate_id_to_ulid", "persona-wire", "pw-migrate" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
