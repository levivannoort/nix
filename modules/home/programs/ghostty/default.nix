{ pkgs, ... }:

{
  # written as a literal config file rather than through `programs.ghostty`,
  # because ghostty's format repeats the `palette` key sixteen times and a nix
  # attrset cannot express duplicate keys. the app itself comes from the
  # homebrew cask so it lands in /Applications and can be pinned to the dock.
  xdg.configFile."ghostty/config".text = ''
    command = ${pkgs.tmux}/bin/tmux

    font-family = "SFMono Nerd Font"
    font-size = 12.5
    font-style = Regular
    font-style-bold = Bold
    font-style-italic = Italic
    font-style-bold-italic = Bold Italic

    background-opacity = 0.95
    background-blur = 16
    window-padding-x = 20
    window-padding-y = 10
    window-decoration = true

    background = #151515
    foreground = #ECECEC
    selection-background = #3B663B
    selection-foreground = #ECECEC
    cursor-color = #dedede
    cursor-text = #2f2b2c
    cursor-style = bar
    cursor-style-blink = true

    palette = 0=#302c2c
    palette = 1=#BCBCBC
    palette = 2=#729464
    palette = 3=#cacaca
    palette = 4=#CECECE
    palette = 5=#b1b1b1
    palette = 6=#7f7f7f
    palette = 7=#dedede
    palette = 8=#5d595b
    palette = 9=#979797
    palette = 10=#989898
    palette = 11=#cacaca
    palette = 12=#656565
    palette = 13=#b1b1b1
    palette = 14=#7f7f7f
    palette = 15=#ffffff

    macos-titlebar-style = hidden
    macos-icon = custom-style
    macos-icon-frame = plastic
    macos-icon-ghost-color = #15239C
    macos-icon-screen-color = #C9C7A2
  '';
}
