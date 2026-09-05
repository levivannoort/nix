{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
    # fish integration is read-only in current home-manager (always on).
  };
}
