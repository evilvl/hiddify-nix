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

  appimage = appimageTools.makeAppImage {
    inherit src;
  };
in
appimageTools.wrapType2 {
  pname = "hiddify";
  inherit version src;

  extraPkgs =
    pkgs: with pkgs; [
      libGL
      mesa
      libX11
      libXcursor
      libXi
      libXrandr
      libXrender
      libXtst
      libxcb
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

  extraInstallCommands = ''
        mkdir -p $out/share/applications
        mkdir -p $out/share/icons/hicolor/512x512/apps

        # desktop file
        cat > $out/share/applications/hiddify.desktop <<EOF
    [Desktop Entry]
    Name=Hiddify
    Comment=Hiddify client
    Type=Application
    Categories=Network;
    Exec=hiddify
    Icon=hiddify
    Terminal=false
    StartupNotify=true
    EOF

        # extract appimage (read-only safe)
        tmp=$(mktemp -d)
        cd $tmp

        # AppImage extract
        ${pkgs.appimage-run}/bin/appimage-run ${src} --appimage-extract >/dev/null 2>&1 || true

        # find icon
        icon=$(find squashfs-root -type f \( -iname "*.png" -o -iname "*.svg" \) | head -n 1 || true)

        if [ -n "$icon" ]; then
          install -Dm644 "$icon" \
            $out/share/icons/hicolor/512x512/apps/hiddify.png
        fi

        cd /
        rm -rf $tmp
  '';

  meta = with lib; {
    description = "Hiddify client";
    homepage = "https://github.com/hiddify/hiddify-app";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "hiddify";
  };
}
