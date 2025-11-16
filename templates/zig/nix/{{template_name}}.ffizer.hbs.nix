{
  pkgs,
  inputs,
  system,
  devLib,
  formatter,
  ...
}@args:
rec {
  zig-overlay = import inputs.zig-overlay { inherit pkgs system; };
  zig-default = zig-overlay."0.15.1";

  shells.default = pkgs.mkShellNoCC {
    packages =
      with pkgs;
      [
        formatter.package
        zig-default
        zls_0_15
      ]
      ++ aliases;
  };

  aliases = devLib.mkAliases {
    ff = formatter.package;
  };
}
