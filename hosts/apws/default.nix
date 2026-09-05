{ hostname, ... }:

{
  networking.hostName = hostname;
  networking.computerName = hostname;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 6;

  # Everything shared with lpws lives in modules/darwin. This host currently
  # adds nothing on top; keep the file so per-host divergence has a home.
}
