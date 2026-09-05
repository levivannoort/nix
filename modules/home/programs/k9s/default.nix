{ ... }:

{
  programs.k9s = {
    enable = true;
    settings.k9s = {
      liveViewAutoRefresh = true;
      refreshRate = 2;
      # No `ui.skin` here on purpose: it names a skin file that must also be
      # deployed, and a missing one leaves k9s unstyled with no error.
    };
  };
}
