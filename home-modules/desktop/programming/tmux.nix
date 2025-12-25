{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true; # 24h clock
    shortcut = "s"; # change prefix to ctrl+s
    mouse = true;
    focusEvents = true;
    terminal = "screen-256color"; # set colors
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

      # Wayland clipboard integration
      set -s copy-command 'wl-copy'
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'wl-copy'
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel 'wl-copy'
    '';
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      # {
      #   plugin = tmuxPlugins.onedark-theme;
      #   extraConfig = ''
      #     set -g @onedark_date_format "%d.%m.%y"
      #   '';
      # }
      # {
      #   plugin = tmuxPlugins.rose-pine;
      #   extraConfig = ''
      #     set -g @rose_pine_variant 'main'
      #   '';
      # }
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_current_text " #W"
          set -g @catppuccin_window_text " #W"
        '';
      }
      # {
      #   plugin = tmuxPlugins.tokyo-night-tmux;
      #   extraConfig = ''
      #     set -g @tokyo-night-tmux_window_id_style digital
      #     set -g @tokyo-night-tmux_pane_id_style hsquare
      #     set -g @tokyo-night-tmux_zoom_id_style dsquare
      #     set -g @tokyo-night-tmux_show_datetime 1
      #     set -g @tokyo-night-tmux_date_format DMY
      #     set -g @tokyo-night-tmux_time_format 24H
      #   '';
      # }
    ];
  };

}
