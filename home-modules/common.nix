{
  config,
  pkgs,
  unstablePkgs,
  lib,
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
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
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

  fonts.fontconfig.enable = true;

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
      md2pdf = ''for file in *.md; do pandoc "$file" -o "''${file%.md}.pdf" --template=$HOME/Templates/eisvogel.tex; done'';
      gocoverage = "go test -coverprofile=.cover.out && go tool cover -html=.cover.out -o coverage.html && zen coverage.html && sleep 1 && rm .cover.out coverage.html";
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.go = {
    enable = true;
    env = {
      GOPATH = ["${config.home.homeDirectory}/.go"];
      GOPRIVATE = ["github.com/faebut/*"];
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

      # Treesitter CLI for nvim parser compilation
      tree-sitter

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
      gofumpt # go formatter
      goimports-reviser # go import reviser
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
      alejandra # lua formatter
      # nixfmt-rfc-style # nix formatter
      marksman
      postgres-language-server # postgres language server
      sqls # sql language server
      pgformatter # sql formatter
      htmx-lsp # htmx language server
      nodePackages.prettier # js/ts/css/html formatter

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
      url."git@github.com:".insteadOf = "https://github.com/";
      advice.addIgnoredFile = false;
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

  # Neovim config - symlink individual files/dirs, excluding lazy-lock.json so each host maintains its own
  home.file.".config/nvim/init.lua".source = ../config/nvim/init.lua;
  home.file.".config/nvim/lua".source = ../config/nvim/lua;
  home.file.".config/nvim/after".source = ../config/nvim/after;
  home.file.".config/nvim/ftdetect".source = ../config/nvim/ftdetect;
  home.file.".config/nvim/snippets".source = ../config/nvim/snippets;

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
