# A FHS for Scientific Computing (and specifically Julia)

This provides a [home-manager](https://github.com/nix-community/home-manager) module that you can use in your flake-based nixos config.

Example usage in a flake-based home-manager setup

```nix
# in flake.nix

inputs.scientific-fhs.url = "github:olynch/scientific-fhs"

# in home-manager config

imports = [ inputs.scientific-fhs.nixosModules.default ];

programs.scientific-fhs = {
  enable = true;
  juliaVersions = [
    {
      version = "julia_18";
      default = true;
    }
    { version = "julia_17"; }
    { version = "julia_16"; }
  ];
  enableNVIDIA = false;
};
```
