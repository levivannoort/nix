{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # was `shortcurt = "b"`: a typo, and the option is `prefix` anyway.
    prefix = "C-b";
    terminal = "tmux-256color";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    historyLimit = 10000;
    escapeTime = 0;
    clock24 = true;
    newSession = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
    ];

    extraConfig = ''
      setw -g pane-base-index 1
      set -g renumber-windows on
      set -g set-clipboard on
      set -g focus-events on
      set -g detach-on-destroy off
      set -g extended-keys on

      # the old config set default-terminal to "alacritty", which is not a
      # terminfo entry. ghostty is the real terminal now.
      set -ga terminal-features ',*:bracketed-paste'
      set -ga terminal-overrides ",xterm-ghostty:Tc,*256color*:smcup@:rmcup@"

      bind r source-file ~/.config/tmux/tmux.conf \; display "reloaded"
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -n C-g popup -d '#{pane_current_path}' -E -w 80% -h 80% lazygit

      # @claude_waiting is set by a claude code hook; the green dot marks which
      # window is waiting on input.
      set -g window-status-format '[#{?@claude_waiting,#[fg=green] • #[fg=default],}#I: #W #F]'
      set -g window-status-current-format '[#{?@claude_waiting,#[fg=green] • #[fg=default],}#I: #W #F]'

      set -g status on
      set -g status-position top
      set -g status-justify centre
      set -g status-interval 1
      set -g status-style "fg=#665c54"
      set -g status-left-style "fg=#928374"
      set -g status-bg default
      set -g status-left ""
      set -g status-right ""
    '';
  };
}
