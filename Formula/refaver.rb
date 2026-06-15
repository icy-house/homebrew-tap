# Homebrew formula for the refaver CLI (Phase 1).
#
# Lives in a tap repo (github.com/icy-house/homebrew-tap) as Formula/refaver.rb.
# Install:  brew install icy-house/tap/refaver
#
# refaver ships as a self-contained zipapp (.pyz): pure-Python, zero deps. We
# download it WITHOUT unpacking (`:nounzip`) and run it with Homebrew's own
# Python in isolation mode (-E -s) so a user's messy system/user Python, a broken
# pip, or PYTHONPATH cannot affect it. No pip/virtualenv build step at all.
#
# The release workflow builds and attaches refaver-<version>.pyz; update `url`
# and `sha256` here on each tagged release.
class Refaver < Formula
  desc "Reset Safari's cached favicons for a site — no Terminal gymnastics"
  homepage "https://github.com/icy-house/refaver"
  url "https://github.com/icy-house/refaver/releases/download/v0.1.1/refaver-0.1.1.pyz",
      using: :nounzip
  version "0.1.1"
  sha256 "5a04f001c868a0cb698a2cd814bad4090f34e293d9d049fa40516c98b1c95aee"
  license "MIT"

  depends_on "python@3.12"
  depends_on :macos

  def install
    libexec.install "refaver-#{version}.pyz" => "refaver.pyz"
    (bin/"refaver").write <<~SH
      #!/bin/bash
      exec "#{Formula["python@3.12"].opt_bin}/python3.12" -E -s "#{libexec}/refaver.pyz" "$@"
    SH
  end

  test do
    assert_match "refaver #{version}", shell_output("#{bin}/refaver --version")
  end
end
