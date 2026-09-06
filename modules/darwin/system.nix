{ user, ... }:

{
  # Required on nix-darwin 25.05: user-scoped `system.defaults` and homebrew
  # activation both need to know whose account they apply to.
  system.primaryUser = user;

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      "com.apple.keyboard.fnState" = true;
    };

    dock = {
      autohide = true;
      show-recents = false;
      orientation = "bottom";
      tilesize = 48;
      minimize-to-application = true;
      mru-spaces = false;
      # don't animate opening applications from the dock
      launchanim = false;

      # These must be the on-disk paths after the casks below have installed.
      # A typo here does not fail the build, it silently drops the tile.
      persistent-apps = [
        "/Applications/Firefox.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Ghostty.app"
        "/Applications/TablePlus.app"
        "/Applications/Obsidian.app"
        "/Applications/Discord.app"
        "/Applications/Spotify.app"
      ];
    };

    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };

    screencapture = {
      type = "png";
      disable-shadow = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    loginwindow.GuestEnabled = false;
    menuExtraClock.Show24Hour = true;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };

    # neither of these has a nix-darwin option, so they are written as raw
    # preferences. `DisableAllAnimations` was in the previous config under
    # `system.defaults.finder`, where the option does not exist.
    "com.apple.finder" = {
      DisableAllAnimations = true;
      FK_StandardViewSettings = {
        ListViewSettings = {
          calculateAllSizes = true;
        };
      };
    };
  };

  # `chflags nohidden ~/Library` from the old osx.zsh. activation runs as root
  # now, so the user's home is addressed explicitly.
  system.activationScripts.postActivation.text = ''
    chflags nohidden /Users/${user}/Library || true
  '';

  # Unlock sudo with Touch ID, and keep it working inside tmux.
  security.pam.services.sudo_local.touchIdAuth = true;

  # No manual `activateSettings` hook: `system.activationScripts.postUserActivation`
  # was removed in nix-darwin 25.05 (activation is all root now), and nix-darwin
  # already refreshes the defaults itself on switch.
}
