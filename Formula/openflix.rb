class Openflix < Formula
  desc "AI video generation CLI — 6 providers, recipes, orchestration, quality gate, MCP server"
  homepage "https://github.com/moiz-7/OpenFlix"
  url "https://github.com/moiz-7/OpenFlix/releases/download/v1.0.0/openflix-v1.0.0-macos.tar.gz"
  sha256 "fbafef129444d4145c5a2efb6a888fe9681d1073501eebdcb7bdb77dfabb7ee9"
  license :cannot_represent # proprietary — see LICENSE in the repo
  version "1.0.0"

  depends_on :macos
  depends_on macos: :sonoma # macOS 14+

  def install
    bin.install "openflix"
  end

  test do
    assert_match "1.0.0", shell_output("#{bin}/openflix --version")
    # CLI is JSON-first: providers list emits JSON on stdout
    output = shell_output("#{bin}/openflix providers list")
    assert_match "fal", output
  end
end
