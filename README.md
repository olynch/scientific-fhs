# A FHS for Scientific Computing (and specifically Julia)

Usage instructions:

Either in `home.packages` (for home-manager), or in `environment.systemPackages` (for configuration.nix), put

``` nix
let
    fhsCommand = pkgs.callPackage ./path/to/scientific-fhs {
        juliaVersion = "julia_16";
    };
in
home.packages = [ (fhsCommand "julia" "julia") (fhsCommand "julia-bash" "julia") ];
# or
environment.systemPackages = [ (fhsCommand "julia" "julia") (fhsCommand "julia-bash" "bash") ];
```

Then running `julia` will run `julia` inside the FHS, and running `julia-bash` will run `bash` inside the FHS. You can also use conda inside the FHS, see the documentation for the conda fhs for more details (this is essentially merged with the conda fhs). To install `jupyter`/`IJulia`, you should use the external conda instead of the conda that julia tries to install, because that doesn't work for whatever reason.

Julia will install packages to `$HOME/.julia` as normal, and most things should just work, feel free to open an issue if anything doesn't work. This has been in my personal config for a while and works fine, but I may have not externalized everything in it correctly.
