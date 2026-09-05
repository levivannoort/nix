{ pkgs, user, ... }:

{
  # nix-darwin needs the account declared before home-manager can activate
  # against it. Previously this only existed as an inline attrset in flake.nix
  # for the darwin hosts and was missing entirely for NixOS.
  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  environment.shells = with pkgs; [
    bashInteractive
    zsh
    fish
  ];

  # Only enables the system-level zsh integration; the interactive config lives
  # in modules/home/programs/zsh.
  programs.zsh.enable = true;
}
