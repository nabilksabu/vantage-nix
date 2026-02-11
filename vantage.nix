{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "vantage";
  version = "v1-nix";

  src = pkgs.fetchFromGitHub {
    owner = "niizam";
    repo = "vantage";
    rev = "main";
    sha256 = "sha256-Hp5D5tU4TL/jpTnA/fPawOj4pL8TnQQiWaGM7HyP7L4=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];

  buildInputs = with pkgs; [
    zenity
    xorg.xinput
    networkmanager
    pulseaudio
    bash
  ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
    mkdir -p $out/share/vantage/images

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

    # 4. Patch Shebangs
    patchShebangs $out/bin/vantage

    # 5. Wrap the program
    wrapProgram $out/bin/vantage \
      --prefix PATH : ${pkgs.lib.makeBinPath [ 
        pkgs.zenity 
        pkgs.xorg.xinput 
        pkgs.networkmanager 
        pkgs.pulseaudio 
      ]}
  '';
}
