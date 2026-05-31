{
  lib,
  appimageTools,
  fetchurl,
  pkgs,
  ...
}:

let
  json = builtins.fromJSON (builtins.readFile ../generated/hiddify.json);

  version = json.version;

  src = fetchurl {
    url = json.url;
    sha256 = json.sha256;
  };

in
appimageTools.wrapType2 {
  pname = "hiddify";
  inherit version src;

  extraPkgs =
    pkgs: with pkgs; [
      libGL
      mesa
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb

      gtk3
      glib
      cairo
      pango
      atk
      gdk-pixbuf

      libayatana-appindicator
      dbus
      nss
      nspr
      cups
      alsa-lib
      libepoxy
      zstd
    ];

  meta = with lib; {
    description = "Hiddify client";
    homepage = "https://github.com/hiddify/hiddify-app";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "hiddify";
  };
}
