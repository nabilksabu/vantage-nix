{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "vantage";
  version = "1.0.0";

  # IMPORTANT: Change this to ./. so it uses the files in YOUR repo
  src = ./.; 

  nativeBuildInputs = [ pkgs.makeWrapper ];

  buildInputs = with pkgs; [
    zenity
    xorg.xinput
    networkmanager
    pulseaudio
    bash
  ];

  # We can remove the "phases" line; Nix handles this automatically
  
  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $out/share/vantage/images

    # 1. Install script
    cp vantage.sh $out/bin/vantage
    chmod +x $out/bin/vantage

    # 2. Install icon and images
    cp icon.png $out/share/pixmaps/vantage.png
    cp images/* $out/share/vantage/images/

    # 3. Create a Universal XDG Desktop Entry
    cat <<EOF > $out/share/applications/vantage.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Vantage
Comment=Vantage Management Tool
Exec=$out/bin/vantage
Icon=$out/share/pixmaps/vantage.png
Terminal=false
StartupNotify=true
Categories=Settings;HardwareSettings;Utility;
Keywords=vantage;network;audio;input;
EOF

    # 4. Patch Shebangs (Fixes #!/bin/bash for NixOS)
    patchShebangs $out/bin/vantage

    # 5. Wrap the program so it finds its dependencies
    wrapProgram $out/bin/vantage \
      --prefix PATH : ${pkgs.lib.makeBinPath [ 
        pkgs.zenity 
        pkgs.xorg.xinput 
        pkgs.networkmanager 
        pkgs.pulseaudio 
      ]}
  '';
}
