class PersonaWire < Formula
  desc "persona-wire unified CLI — clap-based bin dispatching subcommands (init / node / edge / spec / projection / wire-init / wire-close / mcp). The `mcp` subcommand boots the stdio MCP server (persona-wire-mcp lib)."
  homepage "https://github.com/ynishi/persona-wire"
  version "0.12.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.12.1/persona-wire-aarch64-apple-darwin.tar.xz"
      sha256 "d875e1c56eec7a4b07458a69b0c50a1c6aeddfe8481fc9e299e6f1e777cd4fd7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.12.1/persona-wire-x86_64-apple-darwin.tar.xz"
      sha256 "0031e780042deb7af2d57be0ee99f8e9e24f7f5d48c48819eea46d9507cb8139"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.12.1/persona-wire-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc62406b4cab99f6053dcac15da6f3bd5fd0a5ee3b44a7cf88d06d79498b0652"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.12.1/persona-wire-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "52f4f8078cdff2ff4f78cefdd1caede4ef96c0f78097114e6bff7c32733a4459"
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
