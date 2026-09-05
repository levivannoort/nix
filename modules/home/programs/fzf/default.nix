{ ... }:

{
  programs.fzf = {
    enable = true;

    # `keybindings` and `fuzzyCompletion` are nix-darwin/NixOS `programs.fzf`
    # options and do not exist in home-manager. The equivalent here is the
    # per-shell integration toggle, which installs both the keybindings and the
    # completion script.
    enableZshIntegration = true;

    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];

    tmux.enableShellIntegration = true;
  };
}
