{
  config,
  pkgs,
  unstablePkgs,
  ...
}: {
  home.username = "faebut";
  home.homeDirectory = "/home/faebut";
  home.stateVersion = "25.11";
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
  };

  # programs.gpg = {
  #   enable = true;
  # };
  #
  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  #   enableZshIntegration = true;
  #
  # };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/.nixos-dotfiles#";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.go = {
    enable = true;
    env = {
      GOPATH = ["${config.home.homeDirectory}/.go"];
    };
  };

  home.packages = with pkgs;
    [
      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      fzf # A command-line fuzzy finder

      # networking tools
      mtr # A network diagnostic tool
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      # misc
      file
      which
      tree
      gnutar
      gawk
      zstd
      gnupg

      # window manager
      rofi
      waybar
      hyprpaper
      brightnessctl # control brightness
      pamixer # control volume/faebut/nix-secrets/src/branch/main/
      notify # send desktop notifications

      # productivity
      glow # markdown previewer in terminal
      libreoffice

      btop # replacement of htop/nmon

      # system tools
      lm_sensors # for `sensors` command
      pciutils # lspci
      usbutils # lsusb
      networkmanagerapplet

      # devtools
      beekeeper-studio
      posting # API client
      gh # github client
      air # live go updating
      tmuxifier # tmux session management

      # auth
      gcr

      # proglang
      nodejs
      gopls # golang
      templ # go templating
      cargo # rust package manager
      rustc # rust compiler
      (python3.withPackages (python-pkgs:
        with python-pkgs; [
          pandas
          requests
        ]))

      # language-servers for nvim
      # nixd # nix language server
      # nixfmt-rfc-style # nix formatter
      # lua-language-server # lua
      # vscode-langservers-extracted # html/css/json
      # htmx-lsp # htmx
      # htmx-lsp2 # htmx alternative lsp. try this one
      # tailwindcss-language-server # tailwind lsp
      # prettierd # formatting
      # prettier # formatting

      # graphical tools
      nautilus
      file-roller
    ]
    # add unstable packages
    ++ (with unstablePkgs; [
      # crush
    ]);

  # kitty terminal
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Fabian Trost";
        email = "faebutrost@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  programs.lazygit = {
    enable = true;
    settings.enableZshIntegration = true;
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      # add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      # line_break.disabled = true;
    };
  };

  # hyprland

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      # package = pkgs.rose-pine-gtk-theme;
      # name = "rose-pine";
      package = pkgs.qogir-theme;
      name = "Qogir-Dark";
    };
    iconTheme = let
      theme = (
        pkgs.colloid-icon-theme.override {
          colorVariants = ["purple"];
        }
      );
    in {
      package = theme;
      name = "Colloid-Purple-Dark";
    };
    gtk2 = {
      enable = true;
      theme = {
        # package = pkgs.rose-pine-gtk-theme;
        # name = "rose-pine";
        package = pkgs.qogir-theme;
        name = "Qogir-Dark";
      };
    };
    gtk3 = {
      enable = true;
      # colorScheme = "dark";
      theme = {
        # package = pkgs.rose-pine-gtk-theme;
        # name = "rose-pine";
        package = pkgs.qogir-theme;
        name = "Qogir-Dark";
      };
      # extraConfig.gtk-application-prefer-dark-theme = true;
    };
    gtk4 = {
      enable = true;
      colorScheme = "dark";
      theme = {
        # package = pkgs.rose-pine-gtk-theme;
        # name = "rose-pine";
        # package = pkgs.juno-theme;
        # name = "Juno-mirage";
        package = pkgs.qogir-theme;
        name = "Qogir-Dark";
        # package = pkgs.colloid-gtk-theme;
        # name = "Colloid-Dark";
      };
    };
  };

  home.pointerCursor = {
    name = "Hackneyed";
    package = pkgs.hackneyed;
    size = 48;
    hyprcursor = {
      enable = true;
      size = 48;
    };
    gtk.enable = true;
  };

  services.hypridle.enable = true;
  services.protonmail-bridge.enable = true;

  home.file.".config/kitty".source = ../config/kitty;
  home.file.".config/nvim".source = ../config/nvim;
  home.file.".config/hypr".source = ../config/hypr;
  home.file.".config/waybar".source = ../config/waybar;
  home.file.".config/swaync".source = ../config/swaync;
  home.file.".config/rofi".source = ../config/rofi;
  home.file.".config/btop".source = ../config/btop;
}
