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
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # GPG agent environment variables - moved here from sessionVariables (needed to fix login error!)
    initContent = ''
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)";
    '';

    shellAliases = {
      nrs = "nixos-rebuild switch --flake ~/.nixos-dotfiles# --sudo";
      gpgrestart = "gpgconf --kill gpg-agent";
      gitlog = "git log --graph --all --decorate";
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
      pamixer # control volume/faebut/nix-secrets/src/branch/main/
      libnotify # send desktop notifications

      # productivity
      glow # markdown previewer in terminal

      btop # replacement of htop/nmon

      # system tools
      lm_sensors # for `sensors` command
      pciutils # lspci
      usbutils # lsusb
      networkmanagerapplet

      # devtools
      posting # API client
      gh # github client
      air # live go updating
      tmuxifier # tmux session management

      # auth
      gcr
      age-plugin-yubikey

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
      nixd # nix language server, not installed in nvim
      lua-language-server # lua language server
      stylua # lua formatter
      # nixfmt-rfc-style # nix formatter

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
    signing = {
      key = "74E8953715B50171";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Fabian Trost";
        email = "ftrost@proton.me";
      };
      init.defaultBranch = "main";
      gpg.program = "gpg";
      tag.gpgSign = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings.enableZshIntegration = true;
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
    };
  };

  # hyprland

  # GTK theme and icons configured per-desktop in desktop/hyprland or desktop/gnome

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

  services.protonmail-bridge.enable = true;

  home.file.".config/kitty".source = ../config/kitty;
  home.file.".config/nvim".source = ../config/nvim;
  home.file.".config/waybar".source = ../config/waybar;
  # home.file.".config/swaync".source = ../config/swaync;
  home.file.".config/rofi".source = ../config/rofi;
  home.file.".config/btop".source = ../config/btop;

  # GTK bookmarks (Nautilus sidebar) - base bookmarks
  # Note: smb-share.nix will append to this if SMB is configured
  home.file.".config/gtk-3.0/bookmarks-base".text = ''
    file://${config.home.homeDirectory}/Downloads
  '';
}
