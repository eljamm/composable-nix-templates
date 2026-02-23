{
  lib,
  pkgs,
  devLib,
  formatter,
  ...
}:
lib.makeExtensible (self: {
  shells.default = pkgs.mkShellNoCC {
    packages =
      with pkgs;
      [
        elmPackages.elm-format
        elmPackages.elm-language-server
      ]
      ++ self.aliases;
  };

  aliases = devLib.mkAliases {
    ff = formatter.package;
  };
})
