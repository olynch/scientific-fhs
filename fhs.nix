{ lib
, pkgs
, enableJulia ? true
, juliaVersion ? "1.10.1"
, enableConda ? false
, enablePython ? false
, enableQuarto ? true
, condaInstallationPath ? "~/.conda"
, condaJlEnv ? "conda_jl"
, pythonVersion ? "3.8"
, enableGraphical ? false
, enableNVIDIA ? false
, enableNode ? false
, commandName ? "scientific-fhs"
, commandScript ? "bash"
, texliveScheme ? pkgs.texlive.combined.scheme-minimal
, extraOutputsToInstall ? ["man" "dev"]
}:

with lib;
let
  standardPackages = pkgs:
    with pkgs;
    [
      autoconf
      binutils
      clang
      cmake
      expat
      gcc
      gfortran
      gmp
      gnumake
      gperf
      libxml2
      m4
      nss
      openssl
      stdenv.cc
      unzip
      utillinux
      which
      texliveScheme
      ncurses
      poetry
    ] ++ lib.optional enableNode pkgs.nodejs;

  graphicalPackages = pkgs:
    with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      # customGr
      dbus
      expat
      ffmpeg
      fontconfig
      freetype
      gettext
      glfw
      glib
      glib.out
      gnome2.GConf
      gtk2
      gtk2-x11
      gtk3
      libGL
      libcap
      libdrm
      libgnome-keyring3
      libgpg-error
      libnotify
      libpng
      libsecret
      libselinux
      libuuid
      libxkbcommon
      mesa # TODO: Use libgbm instead when upstream fixed: https://github.com/NixOS/nixpkgs/issues/218232
      ncurses
      nspr
      nss
      pango
      pango.out
      pdf2svg
      systemd
      vulkan-loader
      vulkan-headers
      vulkan-validation-layers
      wayland
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXrender
      xorg.libXt
      xorg.libXtst
      xorg.libXxf86vm
      xorg.libxcb
      xorg.libxkbfile
      xorg.xorgproto
      zlib
    ];

  nvidiaPackages = pkgs:
    with pkgs; [
      cudatoolkit_11
      cudnn_cudatoolkit_11
      linuxPackages.nvidia_x11
    ];


  quartoPackages = pkgs:
  let
    quarto = pkgs.callPackage ./quarto.nix {
      rWrapper = null;
    };
  in [ quarto ];

  condaPackages = pkgs:
    with pkgs;
    [ (callPackage ./conda.nix { installationPath = condaInstallationPath; }) ];

  pythonPackages = pkgs:
    with pkgs;
    [
      (python3.withPackages (ps: with ps; [
        jupyter jupyterlab numpy scipy pandas matplotlib scikit-learn tox pygments
      ]))
    ];

  targetPkgs = pkgs:
    (standardPackages pkgs)
    ++ optionals enableGraphical (graphicalPackages pkgs)
    ++ optionals enableJulia [(pkgs.callPackage ./julia.nix { juliaVersion=juliaVersion; })]
    ++ optionals enableQuarto (quartoPackages pkgs)
    ++ optionals enableConda (condaPackages pkgs)
    ++ optionals enableNVIDIA (nvidiaPackages pkgs)
    ++ optionals enablePython (pythonPackages pkgs);

  std_envvars = ''
    export EXTRA_CCFLAGS="-I/usr/include"
    export FONTCONFIG_FILE=/etc/fonts/fonts.conf
    export LIBARCHIVE=${pkgs.libarchive.lib}/lib/libarchive.so
  '';

  graphical_envvars = ''
    export QTCOMPOSE=${pkgs.xorg.libX11}/share/X11/locale
  '';

  conda_envvars = ''
    export NIX_CFLAGS_COMPILE="-I${condaInstallationPath}/include"
    export NIX_CFLAGS_LINK="-L${condaInstallationPath}lib"
    export PATH=${condaInstallationPath}/bin:$PATH
    # source ${condaInstallationPath}/etc/profile.d/conda.sh
  '';

  conda_julia_envvars = ''
    export CONDA_JL_HOME=${condaInstallationPath}/envs/${condaJlEnv}
  '';

  nvidia_envvars = ''
    export CUDA_PATH=${pkgs.cudatoolkit_11}
    export LD_LIBRARY_PATH=${pkgs.cudatoolkit_11}/lib:${pkgs.cudnn_cudatoolkit_11}/lib:${pkgs.cudatoolkit_11.lib}/lib:${pkgs.zlib}/lib:$LD_LIBRARY_PATH
    export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
  '';

  envvars = std_envvars + optionalString enableGraphical graphical_envvars
    + optionalString enableConda conda_envvars
    + optionalString (enableConda && enableJulia) conda_julia_envvars
    + optionalString enableNVIDIA nvidia_envvars;

  multiPkgs = pkgs: with pkgs; [ zlib ];

  condaInitScript = ''
    conda-install
    conda create -n ${condaJlEnv} python=${pythonVersion}
  '';
in
pkgs.buildFHSUserEnv {
  inherit multiPkgs extraOutputsToInstall;
  targetPkgs = targetPkgs;
  name = commandName; # Name used to start this UserEnv
  runScript = commandScript;
  profile = envvars;
}
