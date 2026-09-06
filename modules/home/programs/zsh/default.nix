{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    # singular `autosuggestion`; renamed from `autosuggestions` in
    # home-manager 24.05.
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # `histSize`/`histFile` are not home-manager options; history lives in its
    # own submodule. the sizes match the old .zshrc.
    history = {
      size = 1048576;
      save = 1048576;
      path = "${config.home.homeDirectory}/.history";
      extended = true;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    historySubstringSearch.enable = true;

    sessionVariables = {
      BROWSER = "firefox";
      AWS_DEFAULT_PROFILE = "default";
      AWS_SDK_LOAD_CONFIG = "1";
      AWS_CONFIG_FILE = "${config.home.homeDirectory}/.aws/config";
    };

    shellAliases = {
      # directories
      nix-config = "cd ${config.home.homeDirectory}/personal/nix";
      personal = "cd ${config.home.homeDirectory}/personal";
      work = "cd ${config.home.homeDirectory}/work";

      # git
      gs = "git status";
      gb = "git branch";
      gd = "git diff";
      gch = "git checkout";
      gaa = "git add .";
      gco = "git commit -m";
      gpl = "git pull";
      gps = "git push";

      # kubernetes
      k = "kubectl";

      # terraform / tofu
      tf = "terraform";
      tp = "terraform plan";
      ta = "terraform apply";
      tsw = "terraform workspace select";

      # -l long, -s size in blocks, -A hidden, -F classify, -G colorize
      ll = "ls -lsAFG";
    };

    initContent = ''
      setopt hist_verify inc_append_history
      setopt AUTO_CD EXTENDED_GLOB NO_BEEP
      bindkey -e

      # start tmux on first interactive shell. `command tmux` avoids the alias,
      # and the ls check is quiet so it does not print on a fresh machine.
      if [[ -z "$TMUX" ]] && ! command tmux list-sessions &>/dev/null; then
        command tmux
      fi

      # prompt: colours reference the ghostty palette in
      # modules/home/programs/ghostty, so the two stay visually consistent.
      setopt PROMPT_SUBST

      parse_git_branch() {
        git branch 2>/dev/null | sed -n -e 's/^\* \(.*\)/\1 /p'
      }

      # %F{2} green (matches the ghostty selection colour), %F{3} bright gray,
      # %F{7} cursor colour.
      export PROMPT='%F{2}%n%f@%F{3}''${(L)HOST%%.*}%f %F{2}%(2~|%2~|%~)%f %F{3}$(parse_git_branch)%F{7}$%f '
    '';
  };

  home.sessionPath = [ "${config.home.homeDirectory}/go/bin" ];

  # the old .fzf.zsh sourced completion and key-bindings from
  # /opt/homebrew/opt/fzf; programs.fzf's shell integration replaces it.
  home.packages = [ pkgs.zsh-completions ];
}
