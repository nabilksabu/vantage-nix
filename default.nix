{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation rec {
  pname = "vantage";
  version = "1.0.0";

  # Uses the files in the same folder as this default.nix
  src = ./.; 

  nativeBuildInputs = [ pkgs.makeWrapper ];

  buildInputs = with pkgs; [
    zenity
    xorg.xinput
    networkmanager
    pulseaudio
    bash
  ];

  installPhase = ''
    # Create all necessary directories in the Nix store
    mkdir -p $out/bin $out/share/applications $out/share/pixmaps $out/share/vantage/images

    # 1. Install the executable script
    cp vantage.sh $out/bin/vantage
    chmod +x $out/bin/vantage

    # 2. Install the icon
    cp icon.png $out/share/pixmaps/vantage.png

    # 3. Install the UI Images (matching your 'Images' folder name)
    # The /. syntax ensures all contents are copied correctly
    cp -r Images/. $out/share/vantage/images/

    # 4. Create the Desktop Entry for your app menu
    cat <<EOF > $out/share/applications/vantage.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Vantage
Comment=Hardware and System Management Tool
Exec=$out/bin/vantage
Icon=vantage
Terminal=false
Categories=Settings;HardwareSettings;Utility;
Keywords=vantage;network;audio;input;
EOF

    # 5. Fix script shebangs for the Nix store environment
    patchShebangs $out/bin/vantage

    # 6. Wrap the program so it knows exactly where its dependencies are
    wrapProgram $out/bin/vantage \
      --prefix PATH : ${pkgs.lib.makeBinPath [ 
        pkgs.zenity 
        pkgs.xorg.xinput 
        pkgs.networkmanager 
        pkgs.pulseaudio 
      ]}
  '';

  meta = with pkgs.lib; {
    description = "A management tool for system settings";
    homepage = "https://github.com/nabilksabu/vantage-nix";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
