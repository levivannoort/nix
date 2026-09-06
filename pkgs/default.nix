# custom packages, exposed through the flake's overlay so they are reachable as
# `pkgs.<name>` from any module.
pkgs: {
  sf-mono-nerd-font = pkgs.callPackage ./sf-mono-nerd-font { };
}
