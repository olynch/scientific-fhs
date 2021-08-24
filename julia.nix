{ stdenv, lib, fetchurl, zlib, glib, xorg, dbus, fontconfig, freetype, libGL }:

let
  makeJulia = version: sha256:
    stdenv.mkDerivation {
      name = "julia-${version}";
      src = fetchurl {
        url = "https://julialang-s3.julialang.org/bin/linux/x64/${
            lib.versions.majorMinor version
          }/julia-${version}-linux-x86_64.tar.gz";
        inherit sha256;
      };
      installPhase = ''
        mkdir $out
        cp -R * $out/

        # Patch for https://github.com/JuliaInterop/RCall.jl/issues/339.

        echo "patching $out"
        cp -L ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/lib/julia/
      '';
      dontStrip = true;
      ldLibraryPath = lib.makeLibraryPath [
        stdenv.cc.cc
        zlib
        glib
        xorg.libXi
        xorg.libxcb
        xorg.libXrender
        xorg.libX11
        xorg.libSM
        xorg.libICE
        xorg.libXext
        dbus
        fontconfig
        freetype
        libGL
      ];
    };
in {
  julia_16 =
    makeJulia "1.6.2" "sha256-PrS1d1sN8a049sQJ6YlQGrRFyVvLAasCvWD1vR6CMkA=";
  julia_15 =
    makeJulia "1.5.4" "1icb3rpn2qs6c3rqfb5rzby1pj6h90d9fdi62nnyi4x5s58w7pl0";
  julia_10 =
    makeJulia "1.0.5" "00vbszpjmz47nqy19v83xa463ajhzwanjyg5mvcfp9kvfw9xdvcx";
}
