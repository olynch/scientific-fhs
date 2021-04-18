{ runCommand, fetchurl, makeWrapper, installationPath }:

let
  conda_version = "4.6.14";
  conda_src = fetchurl {
    url =
      "https://repo.continuum.io/miniconda/Miniconda3-${conda_version}-Linux-x86_64.sh";
    sha256 = "1gn43z1y5zw4yv93q1qajwbmmqs83wx5ls5x4i4llaciba4j6sqd";
  };

in runCommand "conda-install" { buildInputs = [ makeWrapper ]; } ''
  mkdir -p $out/bin
  cp ${conda_src} $out/bin/miniconda-installer.sh
  chmod +x $out/bin/miniconda-installer.sh
  makeWrapper                            \
    $out/bin/miniconda-installer.sh      \
    $out/bin/conda-install               \
    --add-flags "-p ${installationPath}" \
    --add-flags "-b"
''
