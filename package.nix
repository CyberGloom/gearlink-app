{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "gearlink-app";
  version = "1.0.0";

  dontUnpack = true;

  buildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.chromium}/bin/chromium $out/bin/gearlink \
      --add-flags '--app="https://gearlink.asus.com/en"' \
      --add-flags '--enable-features=WebHID' \
      --add-flags '--enable-experimental-web-platform-features'     

    mkdir -p $out/share/applications
    cat <<EOF > $out/share/applications/gearlink.desktop
    [Desktop Entry]
    Name=ASUS Gear Link
    Comment=Web-based peripheral configuration utility
    Exec=$out/bin/gearlink
    Icon=input-gaming
    Terminal=false
    Type=Application
    Categories=Utility;Settings;HardwareSettings;
    StartupWMClass=gearlink.asus.com
    EOF
  '';
}
