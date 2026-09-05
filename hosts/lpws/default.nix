{ hostname, ... }:

{
  networking.hostName = hostname;
  networking.computerName = hostname;

  # nix-darwin needs an explicit platform; passing `system` to darwinSystem is
  # deprecated and does not populate this.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # nix-darwin's own state version. Do not bump without reading the release
  # notes — it is not the nixpkgs release.
  system.stateVersion = 6;

  # `services.nix-daemon.enable` was removed in nix-darwin 25.05; the daemon is
  # managed unconditionally now. Keeping it here was a hard eval error.

  # Personal machine extras on top of modules/darwin/homebrew.nix. Homebrew
  # lists are merged by the module system, so these append rather than replace.
  homebrew.casks = [
    "obs"
  ];

  homebrew.masApps = {
    "WireGuard" = 1451685025;
  };
}
