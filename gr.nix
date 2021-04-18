{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "gr";
  src = fetchurl {
    url =
      "https://github.com/sciapp/gr/releases/download/v0.48.0/gr-0.48.0-Linux-x86_64.tar.gz";
    sha256 = "1a75kky2prwx1bhjpjikpvxvniz85k5i1xszpvdbnwyhgcq8nn57";
  };
  installPhase = ''
    mkdir $out
    cp -R * $out/
  '';
  dontStrip = true;
}
