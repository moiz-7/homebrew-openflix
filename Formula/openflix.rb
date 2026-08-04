class Openflix < Formula
  desc "AI video generation CLI — 6 providers, recipes, orchestration, quality gate, MCP server"
  homepage "https://github.com/moiz-7/OpenFlix"
  url "https://github.com/moiz-7/OpenFlix/releases/download/v1.0.1/openflix-v1.0.1-macos.tar.gz"
  sha256 "4653c84abcacd1ce91a54e6fd884f41c4a0863960d4e639b4f927a64f40d5edb"
  license :cannot_represent # proprietary — see LICENSE in the repo
  version "1.0.1"

  depends_on :macos
  depends_on macos: :sonoma # macOS 14+

  def install
    bin.install "openflix"
  end

  test do
    assert_match "1.0.1", shell_output("#{bin}/openflix --version")
    # CLI is JSON-first: providers list emits JSON on stdout
    output = shell_output("#{bin}/openflix providers list")
    assert_match "fal", output
  end
end
