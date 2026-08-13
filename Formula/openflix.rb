class Openflix < Formula
  desc "AI video generation CLI — multi-provider, recipes, orchestration, quality gate, MCP server"
  homepage "https://github.com/moiz-7/OpenFlix"
  url "https://github.com/moiz-7/OpenFlix/releases/download/v1.1.0/openflix-v1.1.0-macos.tar.gz"
  sha256 "26f082074b61f03ac56525a02417a5d350e7d59830024746dee5fe97e62f7e7a"
  license :cannot_represent # proprietary — see LICENSE in the repo
  version "1.1.0"

  depends_on macos: :sonoma # macOS 14+; this alone implies macOS-only
  # No `depends_on arch:` — the release binary is universal (arm64 + x86_64).
  # v1.0.0 was arm64-only with no guard, so Intel Macs installed a binary that
  # could not execute; the release workflow now verifies both slices exist.

  def install
    bin.install "openflix"
  end

  test do
    assert_match "1.1.0", shell_output("#{bin}/openflix --version")
    # CLI is JSON-first: providers list emits JSON on stdout
    output = shell_output("#{bin}/openflix providers list")
    assert_match "fal", output
  end
end
