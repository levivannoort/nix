{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    # Was `shortcurt = "b"` — a typo for an option that does not exist under
    # that name either. The option is `prefix`, and it takes a full key spec.
    prefix = "C-b";

    # `screen-256color` lacks italics/truecolor. tmux-256color is the correct
    # terminfo for tmux itself; the client terminal is handled by the override
    # below.
    terminal = "tmux-256color";

    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    historyLimit = 10000;
    clock24 = true;
    newSession = true;
    escapeTime = 10;

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

      # The previous config did `set -g default-terminal "alacritty"`, which is
      # not a terminfo entry tmux can use. Advertise truecolor for the outer
      # terminal instead.
      set -sa terminal-features ',alacritty:RGB'
      set -sa terminal-overrides ',alacritty:Tc'

      # Splits and new windows inherit the current directory.
      bind - split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind -n C-g popup -d '#{pane_current_path}' -E -w 80% -h 80% lazygit

      set -g status on
      set -g status-position top
      set -g status-justify centre
      set -g status-interval 5
      set -g status-style "bg=default,fg=#665c54"
      set -g status-left ""
      set -g status-right ""
      set -g window-status-format '[#I: #W #F]'
      set -g window-status-current-format '#[fg=#ebdbb2][#I: #W #F]'
    '';
  };
}
