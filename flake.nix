{
  description = "NixOS configuration and home-manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:Misterio77/nix-colors";

    # secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      # INFO: shallow does not work?
      url = "git+ssh://git@codeberg.org/faebut/nix-secrets.git";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # zen browser
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # affinity
    affinity-nix.url = "github:mrshmllow/affinity-nix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    unstablePkgs = import inputs.unstable {
      localSystem = system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "beekeeper-studio-5.5.7"
        ];
      };
    };
  in {
    nixosConfigurations.nixpad1 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        unstablePkgs = unstablePkgs;
      };
      modules = [
        {nixpkgs.hostPlatform = system;}
        ./nixos
        ./nixos/desktop/hyprland
        ./hosts/common
        ./hosts/common/users/faebut
        ./hosts/common/optional/yubikey
        ./hosts/nixpad1/configuration.nix
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
        inputs.nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.faebut.imports = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              ./home-modules/common.nix
              ./home-modules/desktop
              ./home-modules/desktop/programming
              ./home-modules/desktop/hyprland
              ./home-modules/faebut/common
            ];
            backupFileExtension = "backup";
            extraSpecialArgs = {
              unstablePkgs = unstablePkgs;
              inherit inputs;
            };
          };
        }
      ];
    };

    nixosConfigurations.sinkbad = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        unstablePkgs = unstablePkgs;
      };
      modules = [
        {nixpkgs.hostPlatform = system;}
        ./nixos
        ./nixos/desktop/hyprland
        ./hosts/common
        ./hosts/common/users/faebut
        ./hosts/common/optional/yubikey
        ./hosts/sinkbad/configuration.nix
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
        inputs.nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.faebut.imports = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              ./home-modules/common.nix
              ./home-modules/desktop
              ./home-modules/desktop/programming
              ./home-modules/desktop/3dprinting
              ./home-modules/desktop/hyprland
              ./home-modules/faebut/common
            ];
            backupFileExtension = "backup";
            extraSpecialArgs = {
              unstablePkgs = unstablePkgs;
              inherit inputs;
            };
          };
        }
      ];
    };

    nixosConfigurations.nixps15 = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        unstablePkgs = unstablePkgs;
      };
      modules = [
        {nixpkgs.hostPlatform = system;}
        ./nixos
        ./nixos/desktop/gnome
        ./nixos/desktop/cosmic
        ./hosts/common
        ./hosts/common/users/faebut
        ./hosts/common/optional/yubikey
        ./hosts/nixps15/configuration.nix
        inputs.nixos-hardware.nixosModules.dell-xps-15-9500
        inputs.nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.faebut.imports = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
              ./home-modules/common.nix
              ./home-modules/desktop
              ./home-modules/desktop/programming
              ./home-modules/desktop/gnome
              ./home-modules/desktop/cosmic
              ./home-modules/desktop/optional/smb-shares.nix
              ./home-modules/desktop/optional/worktools.nix
              ./home-modules/faebut/common
            ];
            backupFileExtension = "backup";
            extraSpecialArgs = {
              unstablePkgs = unstablePkgs;
              inherit inputs;
            };
          };
        }
      ];
    };
  };
}
