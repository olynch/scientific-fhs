{
  inputs = {
    nixpkgs = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      nixosModules.default = import ./module.nix;
    };
}
