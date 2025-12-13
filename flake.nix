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

    # nur
    nur.url = "github:charmbracelet/nur";

    # nix-secrets = {
    #   url = "git+ssh://git@github.com/faebut/nix-secrets.git?shallow=1";
    #   flake = false;
    # };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      unstablePkgs = import inputs.unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      system = "x86_64-linux";
    in
    {

      nixosConfigurations.nixpad1 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos
          ./users/faebut.nix
          ./nixos/desktop/hyprland
          ./hosts/common
          ./hosts/nixpad1/configuration.nix
          # nur.modules.nixos.default
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.faebut.imports = [
                ./home-modules/common.nix
                ./home-modules/desktop
                ./home-modules/faebut/common
                ./home-modules/programming
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
        inherit system;
        modules = [
          ./nixos
          ./users/faebut.nix
          ./nixos/desktop/hyprland
          ./hosts/common
          ./hosts/sinkbad/configuration.nix
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.faebut.imports = [
                ./home-modules/common.nix
                ./home-modules/desktop
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
