{ pkgs, ... }:

let
  # SF Mono Nerd Font is not packaged in nixpkgs, so the old config silently
  # fell back to a default font. See modules/darwin/fonts.nix.
  fontFamily = "JetBrainsMono Nerd Font";
in
{
  programs.alacritty = {
    # On macOS the GUI app comes from the homebrew cask so it lands in
    # /Applications and shows up in the Dock; home-manager only owns the config
    # file. On Linux, install the package too.
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.emptyDirectory else pkgs.alacritty;

    settings = {
      window = {
        decorations = "buttonless";
        dynamic_padding = true;
        opacity = 0.98;
        padding = {
          x = 10;
          y = 10;
        };
      };

      # The key is `font`, singular. `fonts` is silently ignored by alacritty,
      # which is why none of this styling ever took effect.
      font = {
        size = 12.5;

        normal = {
          family = fontFamily;
          style = "Regular";
        };
        bold = {
          family = fontFamily;
          style = "Bold";
        };
        italic = {
          family = fontFamily;
          style = "Italic";
        };
        bold_italic = {
          family = fontFamily;
          style = "Bold Italic";
        };
      };

      scrolling.history = 10000;

      general.live_config_reload = true;

      terminal.shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [
          "new-session"
          "-A"
          "-s"
          "main"
        ];
      };
    };
  };
}
