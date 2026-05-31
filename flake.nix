{
  description = "hiddify flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      hiddify = pkgs.callPackage ./pkgs { };

    in
    {
      packages.${system} = {
        hiddify = hiddify;
        default = hiddify;
      };

      homeManagerModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          options.programs.hiddify.enable = lib.mkEnableOption "Hiddify";

          config = lib.mkIf config.programs.hiddify.enable {
            home.packages = [ hiddify ];
          };
        };
    };
}
