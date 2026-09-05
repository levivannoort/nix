# Everyday CLI tooling.
{ pkgs }:

with pkgs;
[
  coreutils
  curl
  wget
  gnugrep
  gnused
  ripgrep
  fd
  tree
  jq
  # `yq` in nixpkgs is the Python wrapper; yq-go is the Go implementation that
  # matches the `yq` most people mean.
  yq-go
  bat
  fzf
  htop
  btop
  sqlite
  gh
  slides
]
++ lib.optionals stdenv.isLinux [
  # procps provides `watch`; it is Linux-only, macOS ships its own.
  procps
]
