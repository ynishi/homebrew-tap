class HtlCli < Formula
  desc "htl command line (also `cargo htl`): check / run / test / fmt / build / pkg / new for Teal projects"
  homepage "https://github.com/ynishi/htl"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.13.0/htl-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f4068bbaf0b5d16e4f17543ae032cccb4f7683fa3f9b4e90f9e1c5bc38691d9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.13.0/htl-cli-x86_64-apple-darwin.tar.xz"
      sha256 "40205cd0420090494df891426dfeefb65395e3f43521e71b9b2e7c150ea50535"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ynishi/htl/releases/download/v0.13.0/htl-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86dc22e566b237f18c0e9d73bb423946f26512b3526f479f68698777561a4309"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ynishi/htl/releases/download/v0.13.0/htl-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f694320a0af13d3e6df5134d9ea1684a73927b4fd5db5ed9475427ac106115f4"
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
      bin.install "cargo-htl", "htl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cargo-htl", "htl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cargo-htl", "htl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cargo-htl", "htl"
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
