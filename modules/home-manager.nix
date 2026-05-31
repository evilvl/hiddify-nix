{
  config,
  lib,
  pkgs,
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
      pkgs.hiddify
    ];
  };
}
