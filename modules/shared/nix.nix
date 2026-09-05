{
  lib,
  mylib,
  user,
  ...
}:

{
  nixpkgs.config = mylib.nixpkgsConfig;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Required for `nix build`/devenv-style clients that pass extra settings.
    trusted-users = [
      "root"
      user
    ];

    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    warn-dirty = false;
  };

  # `nix.settings.auto-optimise-store` is asserted against upstream: it can
  # corrupt the store. The scheduled optimiser is the supported route.
  nix.optimise.automatic = lib.mkDefault true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
}
