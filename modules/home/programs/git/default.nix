{ ... }:

{
  programs.git = {
    enable = true;

    userName = "Levi van Noort";
    userEmail = "73097785+levivannoort@users.noreply.github.com";

    # `init.defaultBranch` and `pull.rebase` are git config keys, not
    # home-manager options: setting them at the top level of programs.git
    # aborts evaluation. they belong in extraConfig.
    extraConfig = {
      core.editor = "vim";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      push.default = "current";
      fetch.prune = true;
      rebase.autoStash = true;
      diff.algorithm = "histogram";
      merge.conflictstyle = "zdiff3";
      column.ui = "auto";
      branch.sort = "-committerdate";

      # clone over https, push over ssh, without rewriting every remote.
      url."git@github.com:".insteadOf = "https://github.com/";
    };

    aliases = {
      st = "status --short --branch";
      co = "checkout";
      br = "branch";
      lg = "log --oneline --graph --decorate --all";
      last = "log -1 HEAD --stat";
      unstage = "restore --staged";
    };

    # replaces core.excludesfile pointing at ~/.gitignore.
    ignores = [
      ".DS_Store"
      "result"
      "result-*"
      ".direnv/"
      ".claude/settings.local.json"
    ];

    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };
  };

  programs.lazygit.enable = true;
}
