{ pkgs, ... }:

{
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  fonts.packages = with pkgs; [
    sf-mono-nerd-font
    nerd-fonts.symbols-only
  ];
}
