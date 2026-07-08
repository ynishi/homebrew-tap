class PersonaWire < Formula
  desc "persona-wire unified CLI — clap-based bin dispatching subcommands (init / node / edge / spec / projection / wire-init / wire-close / mcp). The `mcp` subcommand boots the stdio MCP server (persona-wire-mcp lib)."
  homepage "https://github.com/ynishi/persona-wire"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.12.0/persona-wire-aarch64-apple-darwin.tar.xz"
      sha256 "1107f3b9773e994966f701082c458c950334f28043ea294fb80dda8428323a42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.12.0/persona-wire-x86_64-apple-darwin.tar.xz"
      sha256 "af40b234f17c6f71e8d056f8a6663c0678717a9c031417c8b54d67fcf494f340"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.12.0/persona-wire-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bbd29691fe2a409bb2dfd26393e0512f0026efc314bf539bee17c66a48c7bb71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.12.0/persona-wire-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "94689967ad8de46c90f2fd8a0b4922e404d297f39d310256cfd769f8e97f9507"
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
