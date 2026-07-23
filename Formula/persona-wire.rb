class PersonaWire < Formula
  desc "persona-wire unified CLI — clap-based bin dispatching subcommands (init / node / edge / spec / projection / wire-init / wire-close / mcp). The `mcp` subcommand boots the stdio MCP server (persona-wire-mcp lib)."
  homepage "https://github.com/ynishi/persona-wire"
  version "0.14.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.4/persona-wire-aarch64-apple-darwin.tar.xz"
      sha256 "6550880d4730008c484d9f17c862e32a08b9dca13f40f9fd4156b5279f635b0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.4/persona-wire-x86_64-apple-darwin.tar.xz"
      sha256 "1163003b4dc94ab430c295b62779ffc1a1fa3a0135630ee30b8dd097d4119988"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.4/persona-wire-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4d02d7eef03545528ce54079fb2cf15c4a07d15d0d4ae17cdbe1741426762be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.4/persona-wire-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cbcbdc48b284baae9ad430b5a6171bbf3ff41d65bb0ddc3c00e158341167fd46"
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
