# AGENTS.md

Guide for AI agents working in this NixOS dotfiles repository.

## Repository Overview

This is a **NixOS configuration repository** using flakes and home-manager to manage system and user configurations across multiple machines. The configuration supports both **Hyprland** (Wayland) and **GNOME** desktop environments.

### Key Technologies
- **NixOS** with flakes enabled
- **home-manager** for user-level configuration
- **sops-nix** for secrets management
- **nixos-hardware** for hardware-specific optimizations
- **Hyprland** compositor with custom configs
- **Neovim** (lazy.nvim based config in `config/nvim/`)

### System Architecture
- **Platform**: x86_64-linux
- **Channel**: nixos-25.11 (with unstable overlay)
- **User**: faebut
- **Timezone**: Europe/Zurich
- **Locale**: en_US.UTF-8 with de_CH regional settings
- **Keyboard**: Swiss (ch/sg layout)

## Essential Commands

### System Management

```bash
# Rebuild and switch NixOS configuration (alias defined in home-modules/common.nix)
nrs
# Full command: nixos-rebuild switch --flake ~/.nixos-dotfiles# --sudo

# Update flake inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Check flake configuration
nix flake check

# Show system configuration
nix flake show

# Clean old generations (configured to run weekly automatically)
nix-collect-garbage --delete-old

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback
```

### Build/Test Commands

```bash
# Build configuration without switching
nixos-rebuild build --flake ~/.nixos-dotfiles#

# Build specific host
nixos-rebuild build --flake ~/.nixos-dotfiles#nixpad1
nixos-rebuild build --flake ~/.nixos-dotfiles#sinkbad
nixos-rebuild build --flake ~/.nixos-dotfiles#nixps15

# Test configuration (doesn't set as boot default)
nixos-rebuild test --flake ~/.nixos-dotfiles#

# Format Nix files (nixfmt-rfc-style is available but commented out)
# No formatter currently active in this repo
```

### Diagnostics

```bash
# Check system journal
journalctl -b  # current boot
journalctl -xe # recent entries with explanations

# Check home-manager status
systemctl --user status

# GPG agent restart (useful for Yubikey issues)
gpgconf --kill gpg-agent

# View hardware info
lspci
lsusb
sensors
```

## Repository Structure

```
.
├── flake.nix                    # Main flake configuration, defines all hosts
├── flake.lock                   # Locked dependency versions
├── hosts/                       # Host-specific configurations
│   ├── common/                  # Shared host config
│   │   ├── default.nix         # Custom options (displayScaling)
│   │   ├── sops.nix            # Secrets configuration
│   │   ├── users/faebut/       # User account definition
│   │   └── optional/yubikey/   # Optional Yubikey support
│   ├── nixpad1/                # Lenovo ThinkPad X1 6th gen
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── sinkbad/                # Lenovo ThinkPad X1 13th gen
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── nixps15/                # Dell XPS 15 9500
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── nixos/                      # System-level NixOS modules
│   ├── default.nix             # Base system configuration
│   ├── tailscale.nix           # Tailscale VPN
│   ├── smb-mount.nix           # SMB share mounting
│   └── desktop/                # Desktop environment configs
│       ├── hyprland/           # Hyprland compositor
│       ├── gnome/              # GNOME desktop
│       └── displaymanagers/    # ly, gdm, sddm
├── home-modules/               # home-manager user configurations
│   ├── common.nix              # Base user config (shell, git, gpg)
│   ├── desktop/                # Desktop applications
│   │   ├── default.nix
│   │   ├── hyprland/           # Hyprland-specific home config
│   │   ├── gnome/              # GNOME-specific home config
│   │   ├── programming/        # Dev tools (tmux, crush, database)
│   │   └── common/             # Shared desktop apps
│   └── faebut/                 # User-specific settings
│       └── common/             # SSH, keys, default apps
└── config/                     # Raw config files (symlinked via home.file)
    ├── nvim/                   # Neovim configuration (lazy.nvim)
    ├── hypr/                   # Hyprland config
    ├── waybar/                 # Waybar config and themes
    ├── kitty/                  # Kitty terminal config
    ├── rofi/                   # Rofi launcher config
    └── btop/                   # Btop system monitor config
```

## Hosts Configuration

### Active Hosts

1. **nixpad1** - Lenovo ThinkPad X1 6th gen
   - Desktop: Hyprland
   - Display Manager: ly
   - Display Scaling: 1.25
   - Hibernation enabled
   - ACPI handlers for media/brightness keys

2. **sinkbad** - Lenovo ThinkPad X1 13th gen
   - Desktop: Hyprland
   - Display Manager: ly
   - Display Scaling: 1.0 (default)

3. **nixps15** - Dell XPS 15 9500
   - Desktop: GNOME
   - Display Manager: gdm
   - Display Scaling: 1.0 (default)

### Host Module Pattern

Each host imports:
- `./nixos` - Base system config
- `./nixos/desktop/{hyprland|gnome}` - Desktop environment
- `./hosts/common` - Shared host settings
- `./hosts/common/users/faebut` - User account
- `./hosts/common/optional/yubikey` - Optional Yubikey support
- `./hosts/{hostname}/configuration.nix` - Host-specific config
- `inputs.nixos-hardware.nixosModules.*` - Hardware optimization

Home-manager modules:
- `./home-modules/common.nix` - Base user config
- `./home-modules/desktop` - Desktop applications
- `./home-modules/desktop/programming` - Dev tools
- `./home-modules/desktop/{hyprland|gnome}` - DE-specific
- `./home-modules/faebut/common` - User preferences

## Code Patterns and Conventions

### Nix Module Structure

**Standard module pattern**:
```nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # other modules
  ];
  
  # options definitions (if needed)
  options = {
    # ...
  };
  
  # configuration
  config = {
    # ...
  };
}
```

**Function parameter conventions**:
- Use `config`, `pkgs`, `lib`, `inputs`, `unstablePkgs` consistently
- System-level modules: `{config, pkgs, lib, ...}`
- Home-manager modules: `{config, pkgs, osConfig, ...}` (osConfig for system config access)
- Flake outputs: use `@ inputs:` pattern with `inherit inputs;` in specialArgs

### Package Management

**Installing packages**:
```nix
# System-level (nixos/)
environment.systemPackages = with pkgs; [
  package1
  package2
];

# User-level (home-modules/)
home.packages = with pkgs; [
  stable-package
]
++ (with unstablePkgs; [
  unstable-package
]);
```

**Unstable packages**:
- Unstable nixpkgs is available as `unstablePkgs` in both system and home-manager
- Defined in flake.nix with `allowUnfree = true`
- Use when you need bleeding-edge versions

### Custom Options

**displayScaling option**:
- Defined in `hosts/common/default.nix`
- Set per-host in configuration.nix: `displayScaling = "1.25";`
- Used in Hyprland: `osConfig.displayScaling`
- Allows consistent scaling across monitors

**Yubikey support**:
- Optional module pattern: `yubikey.enable = true;`
- Defined with `lib.mkEnableOption`
- Applied with `lib.mkIf config.yubikey.enable`

### Secrets Management (SOPS)

**Pattern**:
```nix
# hosts/common/sops.nix
sops = {
  defaultSopsFile = "${secretspath}/secrets.yaml";
  defaultSopsFormat = "yaml";
  age.keyFile = "/home/faebut/.config/sops/age/keys.txt";
  
  secrets = {
    secret-name = {
      owner = config.users.users.faebut.name;
      inherit (config.users.users.faebut) group;
    };
  };
};
```

**Important**:
- Secrets are stored in private `nix-secrets` repository (Codeberg)
- SSH key required for access: `git+ssh://git@codeberg.org/faebut/nix-secrets.git`
- Age key must exist at `/home/faebut/.config/sops/age/keys.txt`
- Current secrets: `anthropic-api`, `faebut-pass`

### Config File Symlinking

**Pattern** (in home-modules/):
```nix
home.file.".config/nvim".source = ../config/nvim;
home.file.".config/waybar".source = ../config/waybar;
```

**Important**:
- Raw config files live in `config/` directory
- Symlinked to user home via home-manager
- Neovim uses lazy.nvim plugin manager (managed separately)
- Hyprland config: `config/hypr/hyprland.conf` (loaded via `builtins.readFile`)

### Shell Configuration

**Aliases** (home-modules/common.nix):
```nix
shellAliases = {
  nrs = "nixos-rebuild switch --flake ~/.nixos-dotfiles# --sudo";
  gpgrestart = "gpgconf --kill gpg-agent";
  gitlog = "git log --graph --all --decorate";
};
```

**Shell tools in use**:
- zsh with autosuggestions and syntax highlighting
- starship prompt
- atuin (shell history)
- zoxide (cd replacement)
- lsd (ls replacement)
- fzf (fuzzy finder)

## Desktop Environment Specifics

### Hyprland (Wayland)

**System config** (`nixos/desktop/hyprland/`):
- Enables Hyprland with xwayland support
- xdg-desktop-portal-hyprland
- polkit and gnome-keyring
- System packages: rofi, waybar, brightnessctl, pamixer, pyprland

**Home config** (`home-modules/desktop/hyprland/`):
- hyprland.nix: monitor setup, hyprlock, hyprsunset (blue light filter)
- swaync.nix: notification center
- Config file: `config/hypr/hyprland.conf` (read via builtins.readFile)
- Monitor config uses osConfig.displayScaling

**Tools**:
- Compositor: Hyprland
- Bar: Waybar (themes: rose-pine, catppuccin)
- Launcher: Rofi
- Notifications: SwayNC
- Lock: Hyprlock (with fingerprint support)
- Screenshots: grim + slurp
- Clipboard: wl-clipboard

### GNOME

**System config** (`nixos/desktop/gnome/`):
- GNOME desktop environment
- GDM display manager

**Home config** (`home-modules/desktop/gnome/`):
- dconf settings for dark theme, touchpad
- gnome-shell extensions (appindicator)
- Custom monitors.xml for multi-monitor setup

## Development Tools

**Programming languages**:
- Go: gopls, templ, air (live reload)
- Rust: cargo, rustc
- Python: python3 with pandas, requests
- Node.js: nodejs installed
- Lua: lua-language-server, stylua

**Editor**:
- Neovim (configured in `config/nvim/`)
- lazy.nvim plugin manager
- Language servers: nixd, gopls, lua-language-server
- Default editor via `programs.neovim.defaultEditor = true;`

**Dev tools**:
- Git with GPG signing (key: 74E8953715B50171)
- lazygit (TUI for git)
- gh (GitHub CLI)
- tmux with tmuxifier
- posting (API client)
- Database tools (see `home-modules/desktop/programming/database.nix`)

**Virtualization**:
- libvirt/KVM enabled
- virt-manager GUI
- User in libvirtd group

## Important Patterns

### When Adding New Packages

1. **System-level** (affects all users):
   - Add to `nixos/default.nix` or appropriate desktop module
   - Use when package provides system service or needs root

2. **User-level** (home-manager):
   - Add to `home-modules/common.nix` or relevant category module
   - Preferred for most CLI tools and GUI applications

3. **Unstable packages**:
   - Add to `unstablePkgs` list in home-modules/common.nix:
   ```nix
   ++ (with unstablePkgs; [
     package-name
   ]);
   ```

### When Adding New Host

1. Create directory: `hosts/{hostname}/`
2. Add `configuration.nix` with host-specific settings
3. Generate `hardware-configuration.nix` with `nixos-generate-config`
4. Add to `flake.nix` outputs.nixosConfigurations
5. Set displayScaling if needed
6. Choose desktop environment (hyprland or gnome)
7. Choose display manager (ly, gdm, or sddm)

### When Modifying Desktop Environment

**Hyprland**:
- Config: `config/hypr/hyprland.conf` (raw file)
- Waybar: `config/waybar/` (has multiple theme CSS files)
- System packages: `nixos/desktop/hyprland/default.nix`
- Home config: `home-modules/desktop/hyprland/`

**GNOME**:
- dconf settings: `home-modules/desktop/gnome/default.nix`
- System packages: `nixos/desktop/gnome/default.nix`
- Monitor config: XML in monitors.xml

### When Working with Secrets

1. Ensure access to nix-secrets repository (SSH key required)
2. Add secret to `hosts/common/sops.nix`
3. Secrets are decrypted at build time via sops-nix
4. Reference in configs via `config.sops.secrets.{name}.path`

## Common Gotchas

### Flake-Specific Issues

1. **Flake inputs not updating**: Run `nix flake update` explicitly
2. **Local changes not reflected**: Flakes ignore untracked files - commit or `git add` them
3. **Hash mismatches**: Delete flake.lock and regenerate with `nix flake lock`

### Home-Manager

1. **Symlink conflicts**: home-manager uses `backupFileExtension = "backup";`
2. **Config file changes**: Files in `config/` are symlinked, edit source not destination
3. **Service activation**: Some home-manager services need `systemctl --user daemon-reload`

### Module Loading

1. **Missing imports**: Each default.nix should import submodules
2. **Circular dependencies**: Avoid imports that create loops
3. **specialArgs**: Pass inputs/unstablePkgs via specialArgs in flake.nix

### Desktop Environment

1. **Hyprland monitor config**: Uses `osConfig.displayScaling` from host config
2. **Display manager mismatch**: Each host chooses one (ly, gdm, sddm)
3. **Portal conflicts**: Hyprland needs xdg-desktop-portal-hyprland specifically

### Hardware-Specific

1. **hibernation**: Requires `boot.resumeDevice` set to swap partition UUID
2. **ACPI events**: Configured per-host (see nixpad1 for example)
3. **Hardware optimizations**: Use nixos-hardware modules in flake

### Secrets and Authentication

1. **GPG agent issues**: Run `gpgrestart` alias or `gpgconf --kill gpg-agent`
2. **Yubikey not detected**: Check `services.pcscd.enable = true;`
3. **SSH agent**: Using GPG agent for SSH (`enableSshSupport = true`)

## Testing Workflow

1. **Edit configuration**: Make changes to .nix files
2. **Stage changes**: `git add .` (flakes require tracked files)
3. **Test build**: `nixos-rebuild build --flake .#` (or specific host)
4. **Check result**: `./result/bin/switch-to-configuration test`
5. **Apply if good**: `nrs` (rebuild switch)
6. **Rollback if needed**: Select previous generation at boot, or `nixos-rebuild switch --rollback`

### Validation

```bash
# Check flake syntax
nix flake check

# Evaluate specific host config
nix eval .#nixosConfigurations.nixpad1.config.system.build.toplevel

# Show what would be built
nixos-rebuild dry-build --flake .#

# Show diff of configuration
nixos-rebuild dry-activate --flake .#
```

## Git Workflow

**Current state**:
- On `main` branch
- Modified: flake.lock (likely from recent update)
- User: Fabian Trost <ftrost@proton.me>
- GPG signing enabled by default

**Commit conventions**:
- Use descriptive commit messages
- All commits are GPG-signed automatically
- Recent commits show feature additions and hardware configs

## Package Versions

- **NixOS**: 25.11 (stable channel)
- **Nixpkgs revision**: c6245e83d836 (as of 2025-01-18)
- **Unstable overlay**: Available for newer packages
- **State version**: 25.11 (system and home)

## Additional Notes

### Performance

- **Garbage collection**: Automatic weekly cleanup of old generations
- **Boot generations**: Keeps minimum 5 recent generations
- **Nix CLI helper**: `nh` package installed for better UX

### Security

- Unfree packages allowed: `nixpkgs.config.allowUnfree = true;`
- Permitted insecure: `beekeeper-studio-5.3.4` (explicitly allowed)
- GPG signing: All git commits and tags signed
- Yubikey support: Optional per-host

### Fonts

Installed globally:
- JetBrainsMono Nerd Font
- Font Awesome
- Noto Fonts

### LSP Diagnostics

The repository has some unused parameter warnings in .nix files (e.g., unused `config`, `lib`, `inputs` parameters). These are hints, not errors, and can be cleaned up but don't affect functionality.

### Known Issues

- `nur` input in flake.nix is unused (can be removed if not needed)
- `self` attribute in flake outputs is unused
- Some function parameters are defined but unused (see LSP diagnostics)

## Resources

- NixOS options: https://search.nixos.org/options
- Home-manager options: https://nix-community.github.io/home-manager/options.html
- Hyprland wiki: https://wiki.hyprland.org/
- NixOS hardware: https://github.com/NixOS/nixos-hardware
