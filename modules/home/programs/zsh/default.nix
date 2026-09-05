{ config, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    # Singular `autosuggestion`; it was renamed from `autosuggestions` in
    # home-manager 24.05 and the plural form no longer exists.
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # `histSize`/`histFile` are not home-manager options. History is configured
    # under the `history` submodule.
    history = {
      size = 100000;
      save = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    historySubstringSearch.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -lah";
      cat = "bat --paging=never";
      k = "kubectl";
      tf = "terraform";
      g = "git";
      nrs = "make switch";
    };

    initContent = ''
      setopt AUTO_CD EXTENDED_GLOB NO_BEEP
      bindkey -e
    '';
  };
}
