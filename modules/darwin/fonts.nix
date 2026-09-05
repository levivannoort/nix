{ pkgs, ... }:

{
  # The old alacritty config asked for "SFMono Nerd Font", which is not
  # packaged in nixpkgs (Apple does not redistribute SF Mono, and the patched
  # build is not in nerd-fonts either). JetBrainsMono Nerd Font is the closest
  # drop-in, and is what modules/home/programs/alacritty now references.
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];
}
