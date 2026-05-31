{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.programs.hiddify;
in
{
  options.programs.hiddify = {
    enable = lib.mkEnableOption "Hiddify client";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.hiddify.packages.${pkgs.system}.hiddify
    ];
  };
}
