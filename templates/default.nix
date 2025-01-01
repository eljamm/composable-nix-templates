{ self, ... }:
{
  flake.templates = {
    default = self.templates.rust;

    rust = {
      path = ./rust;
      description = "Basic Rust/Cargo project";
      welcomeText = ''
        # Basic Rust/Cargo Template
        ## Intended usage
        A basic Rust flake template, leveraging [Flake Parts](https://flake.parts),
        [Rust Overlay](https://github.com/oxalica/rust-overlay) and
        [Crane](https://crane.dev/index.html).

        Enter the development environment with `nix develop` and build crates
        with `nix build .#<crate-name>`.

        ## More info
        - [Rust language](https://www.rust-lang.org)
        - [Rust on the NixOS Wiki](https://nixos.wiki/wiki/Rust)
      '';
    };
  };
}
