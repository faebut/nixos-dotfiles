{
  description = "NixOS configuration and home-manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:Misterio77/nix-colors";

    # secrets
    # sops-nix-url = "github:Mic92/sops-nix";
    #
    # nix-secrets = {
    #   url = "git+ssh://git@github.com/faebut/nix-secrets.git";
    #   flake = false;
    # };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.nixpad1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/default.nix
          ./hosts/nixpad1/configuration.nix
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.faebut = import ./home-modules/common.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
