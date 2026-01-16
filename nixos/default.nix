# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# shared default config for all hosts
{
  inputs,
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}: {
  imports = [
    ./tailscale.nix
    ./smb-mount.nix
  ];

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_CH.UTF-8";
    LC_IDENTIFICATION = "de_CH.UTF-8";
    LC_MEASUREMENT = "de_CH.UTF-8";
    LC_MONETARY = "de_CH.UTF-8";
    LC_NAME = "de_CH.UTF-8";
    LC_NUMERIC = "de_CH.UTF-8";
    LC_PAPER = "de_CH.UTF-8";
    LC_TELEPHONE = "de_CH.UTF-8";
    LC_TIME = "de_CH.UTF-8";
  };

  console = {
    # font = "ter-v22n";
    keyMap = "sg";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
  };
  services.libinput.enable = true;

  # services
  services.gvfs.enable = true;

  # flatpak
  services.flatpak.enable = true;

  # CUPS printing with additional drivers
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      hplip
      cups-filters
      cups-browsed
    ];
    # Enable Avahi for network printer discovery
    browsing = true;
    defaultShared = false;
  };

  # Avahi for printer discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  # SMB server for VM file sharing (localhost only)
  services.samba = {
    enable = true;
    openFirewall = false; # Don't open firewall, localhost only
    settings = {
      global = {
        "hosts allow" = "127.0.0.1 192.168.122."; # localhost and libvirt default network
        "hosts deny" = "0.0.0.0/0";
        "server string" = "NixOS Share";
        "netbios name" = "nixps15";
        "security" = "user";
        "guest account" = "nobody";
        "map to guest" = "never";
      };
      "Share" = {
        "path" = "/home/faebut/Share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "faebut";
        "force user" = "faebut";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # Allow SMB from libvirt network only
  networking.firewall = {
    interfaces."virbr0" = {
      allowedTCPPorts = [139 445];
      allowedUDPPorts = [137 138];
    };
  };

  # Set Samba password separately with: sudo smbpasswd -a faebut

  # network management
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # firmware updates
  services.fwupd.enable = true;

  # default applications
  environment.systemPackages = with pkgs; [
    wget
    gcc
    unzip
    age
    sops
    pulseaudio # for audio
    wireplumber
    nh # nix cli helper
    nvd # nix package diff tool
    libinput # device input handling

    pinentry-curses # pinentry tool

    # virtualization
    virt-manager
    spice-gtk # Required for USB redirection in virt-manager
  ];

  # Virtualization with libvirt/KVM
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # Add user to libvirtd group (in users/faebut/default.nix)
  programs.virt-manager.enable = true;

  # SPICE USB redirection support
  virtualisation.spiceUSBRedirection.enable = true;

  # Enable rootless Docker support (user-level containers)
  # Daemon starts automatically, but containers only start if configured with restart policies
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      # Prevent containers from auto-restarting on daemon start
      # Users must explicitly set --restart=always if they want autostart
      live-restore = false;
    };
  };

  # FUSE configuration for rclone mounts
  programs.fuse.userAllowOther = true;

  # editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # shell
  programs.zsh.enable = true;

  # default installed fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
  ];

  # add insecure packages if necessary
  nixpkgs.config.permittedInsecurePackages = [
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-old";
  };

  # Keep last 5 generations (minimum) for rollback safety
  # These are protected from garbage collection
  boot.loader.systemd-boot.configurationLimit = 5;

  system.stateVersion = "25.11";
}
