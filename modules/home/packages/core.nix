# everyday cli tooling.
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
  # `yq` in nixpkgs is the python wrapper; yq-go is the go implementation that
  # matches the `yq` most people mean.
  yq-go
  bat
  fzf
  htop
  btop
  sqlite
  gh
  slides
  lf
  stow
  pass
  uv
  hugo
]
++ lib.optionals stdenv.isLinux [
  # procps provides `watch`; macos ships its own.
  procps
]
