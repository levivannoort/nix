{ pkgs, ... }:

{
  # sf-mono-nerd-font comes from the flake's overlay (see ./pkgs). ghostty asks
  # for family "SFMono Nerd Font", which nixpkgs does not carry and homebrew
  # only offers in a ligaturized variant.
  fonts.packages = with pkgs; [
    sf-mono-nerd-font
    nerd-fonts.symbols-only
  ];
}
