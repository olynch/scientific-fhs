{
  outputs = { self, nixpkgs, ... }:
    {
      nixosModules.default = import ./module.nix;
    };
}
