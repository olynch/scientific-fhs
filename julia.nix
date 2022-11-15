{ stdenv, lib, fetchurl, zlib, glib, xorg, dbus, fontconfig, freetype, libGL }:

let
  makeStdJulia = version: sha256: let
    url = "https://julialang-s3.julialang.org/bin/linux/x64/${
      lib.versions.majorMinor version
    }/julia-${version}-linux-x86_64.tar.gz";
    src = fetchurl {
      inherit url sha256;
    };
  in makeJulia version src;
  makeJulia = version: src:
    stdenv.mkDerivation {
      name = "julia-${version}";
      src = src;
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
in
{
  # julia_19 =
  #   makeJulia "1.9.0-alpha" ./julia-f7b4ebece6-linux-x86_64.tar.gz;
  julia_18 =
    makeStdJulia "1.8.2" "sha256-22312Mt/eeAA15jLi2Vtw2QatZUW1uTlLhZ2UBeJKgA=";
  julia_17 =
    makeStdJulia "1.7.2" "sha256-p1JEck87LeDnJJyGH79kB4JXwW+0IDvnjxz03VlzupU=";
  julia_16 =
    makeStdJulia "1.6.7" "sha256-bEUi1ZXky80AFXrEWKcviuwBdXBT0gc/mdqjnkQrKjY=";
}