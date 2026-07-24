class PersonaWire < Formula
  desc "persona-wire unified CLI — clap-based bin dispatching subcommands (init / node / edge / spec / projection / wire-init / wire-close / mcp). The `mcp` subcommand boots the stdio MCP server (persona-wire-mcp lib)."
  homepage "https://github.com/ynishi/persona-wire"
  version "0.14.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.5/persona-wire-aarch64-apple-darwin.tar.xz"
      sha256 "bacbdbed8a49a8d1665cbdaa9821eb49098b3a1e88bc1861aab635cd0223cda6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.5/persona-wire-x86_64-apple-darwin.tar.xz"
      sha256 "8922c61b49333dff8713150c079f486ca3c4bec7b980da8e72b327f574acb702"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.5/persona-wire-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "64c31a2ec32e69827895d5306a4170342be961fbd38fe5d650a86f90a78f3d61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/persona-wire/releases/download/v0.14.5/persona-wire-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "85b1403241a7d71de8549eeb80b1b04c3650f6cb71ad69b5f5fc8a71e0a3e655"
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
