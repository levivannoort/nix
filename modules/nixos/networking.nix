{ lib, ... }:

{
  # The previous modules/networking/default.nix set `programs.networking.enable`,
  # which is not an option in nixpkgs, nix-darwin or home-manager — it would
  # have aborted evaluation as soon as it was imported anywhere.
  networking = {
    networkmanager.enable = lib.mkDefault true;

    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = [ 22 ];
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = lib.mkDefault false;
      KbdInteractiveAuthentication = false;
    };
  };
}
