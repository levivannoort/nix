{ mylib, ... }:

{
  # `virtualisation.*` is a NixOS-only namespace. This module used to sit in a
  # platform-agnostic directory, which would have failed to evaluate the moment
  # it was imported into a darwin host.
  virtualisation = {
    docker = mylib.enabled // {
      autoPrune = mylib.enabled // {
        dates = "weekly";
      };
    };

    libvirtd = mylib.enabled;
  };

  programs.virt-manager = mylib.enabled;
}
