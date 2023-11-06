{ stdenv, lib, fetchurl, zlib, glib, xorg, dbus, fontconfig, freetype, libGL
, nspr, alsa-lib, nss, libxkbcommon, gmime3, wayland, gtk3, curl, libdrm, qt5, R, libpqxx, autoPatchelfHook }:

let
  makeRstudio = version: sha256:
    stdenv.mkDerivation {
      name = "rstudio-${version}";
      src = fetchurl {
        url =
          "https://download1.rstudio.org/desktop/bionic/amd64/rstudio-${version}-amd64-debian.tar.gz";
        inherit sha256;
      };
      installPhase = ''
        mkdir $out
        cp -R * $out/
      '';
      dontStrip = true;
      nativeBuildInputs = [ autoPatchelfHook ];
      extraAutoPatchelfLibs = [ "${R}/lib/R/lib" ];
      buildInputs = [
        stdenv.cc.cc
        zlib
        glib
        xorg.libXi
        xorg.libxcb
        xorg.libXrender
        xorg.libXcursor
        xorg.libX11
        xorg.libSM
        xorg.libICE
        xorg.libXext
        xorg.libXtst
        xorg.libXdamage
        xorg.libXcomposite
        wayland
        gtk3
        libxkbcommon
        gmime3
        nss
        nspr
        alsa-lib
        dbus
        fontconfig
        freetype
        libGL
        curl
        libdrm
        qt5.full
        R
        libpqxx
      ];
    };
  makeQuarto = version: sha256:
    stdenv.mkDerivation {
      name = "quarto-${version}";
      src = fetchurl {
        url =
          "https://github.com/quarto-dev/quarto-cli/releases/download/v${version}/quarto-${version}-linux-amd64.tar.gz";
        inherit sha256;
      };
      installPhase = ''
        mkdir $out
        cp -R * $out/
      '';
      dontStrip = true;
    };
in {
  rstudio = makeRstudio "2022.02.2-485"
    "995a85a058cbb0f59675399ed30a9f39f62167d5558ac6c0fd4459111b09d7d5";
  quarto = makeQuarto "1.3.450"
    "sha256-bcj7SzEGfQxsw9P8WkcLrKurPupzwpgIGtxoE3KVwAU=";
}
