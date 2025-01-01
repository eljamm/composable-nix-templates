{
  perSystem =
    { devLib, ... }:
    {
      packages = rec {
        default = hello;
        hello = devLib.callCrate ./hello.nix { };
      };
    };
}
