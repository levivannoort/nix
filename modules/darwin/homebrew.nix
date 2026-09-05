{ ... }:

{
  # GUI apps only. Anything with a working darwin build in nixpkgs belongs in
  # modules/home/packages instead.
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;

      # "none" leaves anything installed by hand alone. Switch to "uninstall"
      # once the cask list below matches `brew list` — that makes Homebrew
      # declarative, but the first switch after the change removes every
      # cask/formula not listed here. ("zap" additionally deletes each app's
      # leftover support files.)
      cleanup = "none";
    };

    casks = [
      "alacritty"
      "discord"
      # Renamed upstream from "docker"; ships compose, so no separate
      # docker-compose formula is needed. The old config listed
      # "docker-compose" under casks, where no such cask exists.
      "docker-desktop"
      "figma"
      "firefox"
      "obsidian"
      "slack"
      "spotify"
      "tableplus"
      "visual-studio-code"
      "whatsapp"
    ];

    masApps = {
      "Magnet" = 441258766;
    };
  };
}
