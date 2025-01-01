{ self, inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      # Custom library. Contains helper functions, builders, ...
      legacyPackages.lib = pkgs.callPackage ../lib.nix {
        craneLib = (inputs.crane.mkLib pkgs).overrideToolchain (p: p.rust-bin.stable.latest.default);
      };

      # Flake argument for accessing the custom library more easily:
      # `perSystem = { devLib, ... }:`
      _module.args.devLib = self.legacyPackages.${system}.lib;
    };
}
