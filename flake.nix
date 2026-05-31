{
  description = "flake with hiddify package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            hiddify = final.callPackage ./pkgs { };
          })
        ];
      };

    in
    {
      packages.${system}.hiddify = pkgs.hiddify;

      homeManagerModules.default = import ./modules/home-manager.nix;

      homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./modules/home-manager.nix
        ];
      };
    };
}
