{ pkgs, user, ... }:

{
  users.users.${user} = {
    isNormalUser = true;
    description = "Levi van Noort";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "libvirtd"
    ];
  };

  programs.zsh.enable = true;
  environment.shells = with pkgs; [
    zsh
    fish
  ];
}
