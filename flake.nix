{
  outputs = { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      nixosModules.default = import ./module.nix;
      packages.x86_64-linux.scientific-fhs = pkgs.callPackage ./fhs.nix {
        enableNVIDIA = false;
        juliaVersion = "1.9.3";
      };
    };
}
