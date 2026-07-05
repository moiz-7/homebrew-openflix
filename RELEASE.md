# Cutting a CLI release (makes `brew install` work)

The formula in `Formula/openflix.rb` is correct in shape but has a
`PLACEHOLDER_SHA256` — it cannot install until a real release tarball exists.
Steps to go live:

```bash
# 1. Build a release binary
cd VortexCLI
swift build -c release
# binary: .build/release/openflix

# 2. Package it
VERSION=1.0.0
mkdir -p /tmp/openflix-release && cp .build/release/openflix /tmp/openflix-release/
tar -czf openflix-v$VERSION-macos.tar.gz -C /tmp/openflix-release openflix

# 3. Publish a GitHub release on moiz-7/OpenFlix with the tarball
gh release create v$VERSION openflix-v$VERSION-macos.tar.gz \
  --repo moiz-7/OpenFlix --title "openflix v$VERSION"

# 4. Fill in the real SHA
shasum -a 256 openflix-v$VERSION-macos.tar.gz
# paste into Formula/openflix.rb (sha256 line)

# 5. Publish the tap as its own repo: github.com/moiz-7/homebrew-openflix
#    (Homebrew convention: repo must be named homebrew-<tap>)
#    Then users run:
brew tap moiz-7/openflix
brew install openflix

# 6. Verify end-to-end on a clean machine/user:
brew install moiz-7/openflix/openflix && openflix --version
```

Notes:
- The old `Formula/vortex.rb` was removed 2026-07-04 — it installed a `vortex`
  binary that no longer exists and pointed at `github.com/moizsaeed/OpenFlix`
  (wrong user; real repo is `moiz-7/OpenFlix`).
- The binary is arm64-only as built. For Intel support, build both slices and
  `lipo -create`, or add a `depends_on arch: :arm64` line to the formula.
- Update `version`, `url`, and `sha256` together on every release.
