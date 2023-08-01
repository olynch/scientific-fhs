{
  outputs = { self, nixpkgs, ... }:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    fhsCommand = pkgs.callPackage ./fhs.nix {
      enableNVIDIA = false;
      juliaVersion = "1.9.2";
    };
  in
    {
      nixosModules.default = import ./module.nix;
      packages.x86_64-linux.julia = fhsCommand "julia" "julia";
    };
}
