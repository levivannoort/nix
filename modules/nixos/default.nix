{ mylib, ... }:

{
  imports = [
    ../shared/nix.nix
  ]
  ++ mylib.importModules ./.;
}
