{ ... }:

{
  # Available as a shell, but zsh remains the login shell (see
  # modules/darwin/users.nix and modules/nixos/users.nix).
  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      k = "kubectl";
      g = "git";
    };

    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };
}
