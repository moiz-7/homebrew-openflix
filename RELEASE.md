# Cutting a CLI release (updates `brew install`)

The tap is live (`moiz-7/homebrew-openflix`) and `Formula/openflix.rb` carries
a real URL + SHA for the current release (v1.0.1, universal binary). Steps to
ship a new version:

```bash
# 1. Build a universal release binary (arm64 + x86_64)
cd VortexCLI
swift build -c release --arch arm64 --arch x86_64
# binary: .build/apple/Products/Release/openflix

# 2. Package it
VERSION=1.0.2   # next version
mkdir -p /tmp/openflix-release && cp .build/apple/Products/Release/openflix /tmp/openflix-release/
tar -czf openflix-v$VERSION-macos.tar.gz -C /tmp/openflix-release openflix

# 3. Publish a GitHub release on moiz-7/OpenFlix with the tarball
gh release create v$VERSION openflix-v$VERSION-macos.tar.gz \
  --repo moiz-7/OpenFlix --title "openflix v$VERSION"

# 4. Update the formula: bump `version`, `url`, and `sha256` together
shasum -a 256 openflix-v$VERSION-macos.tar.gz
# paste into Formula/openflix.rb; also update the version asserted in `test do`

# 5. Push the formula change to github.com/moiz-7/homebrew-openflix

# 6. Verify end-to-end:
brew update && brew upgrade openflix && openflix --version
# or on a clean machine: brew install moiz-7/openflix/openflix
```

Notes:
- The binary is **universal** (arm64 + x86_64 via `--arch arm64 --arch x86_64`)
  — keep it that way; do not ship a single-slice tarball.
- Update `version`, `url`, and `sha256` together on every release — a mismatch
  breaks `brew install` with a checksum error.
- The old `Formula/vortex.rb` was removed 2026-07-04 — it installed a `vortex`
  binary that no longer exists and pointed at `github.com/moizsaeed/OpenFlix`
  (wrong user; real repo is `moiz-7/OpenFlix`).
