# terraform and packer are BUSL-licensed and therefore unfree; they resolve
# only because modules/shared/nix.nix sets nixpkgs.config.allowUnfree.
{ pkgs }:

with pkgs;
[
  awscli2
  granted
  terraform
  opentofu
  packer
]
