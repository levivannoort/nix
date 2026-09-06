{ hostname, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = hostname;

  system.stateVersion = "25.05";

  # Convenience for a throwaway VM: SSH with a password, sudo without one.
  # Neither belongs on a real machine.
  security.sudo.wheelNeedsPassword = false;
  services.openssh.settings.PasswordAuthentication = true;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
