{ pkgs, ... }:

let
  # Both GNOME (Wayland) and Hyprland use wl-clipboard
  clipboardCmd = "${pkgs.wl-clipboard}/bin/wl-copy";
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true; # 24h clock
    shortcut = "s"; # change prefix to ctrl+s
    mouse = true;
    focusEvents = true;
    terminal = "tmux-256color"; # set colors
    extraConfig = ''
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf

      # put status bar to top
      set-option -g status-position top

      # correct colors
      set-option -ga terminal-overrides ",xterm*:Tc"

      # act like vim
      setw -g mode-keys vi
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      bind -n M-L next-window
      bind -n M-H previous-window

      # Clipboard integration (adapts to desktop environment)
      set -s copy-command '${clipboardCmd}'
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${clipboardCmd}'
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel '${clipboardCmd}'

      # Update environment variables from shell
      set-option -g update-environment "DOCKER_HOST"

      # Tokyo Night theme
      set -g status-style "bg=#16161e,fg=#a9b1d6"
      set -g status-left "#[bg=#7aa2f7,fg=#16161e,bold] #S #[bg=#16161e] "
      set -g status-right "#[fg=#545c7e]%d.%m.%y #[fg=#a9b1d6]%H:%M "
      set -g status-left-length 30
      set -g status-right-length 30

      set -g window-status-format "#[fg=#545c7e] #I #W "
      set -g window-status-current-format "#[bg=#292e42,fg=#7aa2f7,bold] #I #W "
      set -g window-status-separator ""

      set -g pane-border-style "fg=#3b4261"
      set -g pane-active-border-style "fg=#7aa2f7"

      set -g message-style "bg=#292e42,fg=#a9b1d6"
      set -g message-command-style "bg=#292e42,fg=#a9b1d6"

      set -g mode-style "bg=#283457,fg=#c0caf5"
    '';
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
    ];
  };

}
