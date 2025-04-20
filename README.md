# Description

This project presents a more flexible alternative to using flake templates (which is just a fancy way to`cp -r`) and leverages [ffizer](https://github.com/ffizer/ffizer) to allow you to define custom parameters and compose files across different templates.

Check out [ffizer's documentation](https://ffizer.github.io/ffizer/book/overview.html) for more details on the templating sytax and command-line arguments.

<!-- `$ tree -L 4 --noreport --dirsfirst templates/` as shellSession -->

```shellSession
templates/
├── basic
│   ├── nix
│   │   ├── modules
│   │   │   ├── aliases.ffizer.hbs.nix
│   │   │   ├── devShells.ffizer.hbs.nix
│   │   │   ├── formatting.ffizer.hbs.nix
│   │   │   └── infra.ffizer.hbs.nix
│   │   └── lib.nix
│   ├── flake.ffizer.hbs.nix
│   └── statix.toml
├── go
│   └── _basic -> ../basic
└── rust
    ├── _basic -> ../basic
    ├── nix
    │   ├── crates
    │   │   ├── default.nix
    │   │   └── hello.nix
    │   ├── modules
    │   │   └── rust.nix
    │   └── lib.nix
    ├── src
    │   └── main.rs
    ├── bacon.toml
    ├── Cargo.lock
    └── Cargo.toml
```

# Usage

## Flakes

```shellSession
nix run .#<template_name> -- <output_directory> <args>
```

For example, to generate a Rust template without installing the project, run:

```shellSession
nix run github:eljamm/nix-templates#rust -- test/rust --update-mode override
```

or locally:

```shellSession
nix run .#rust -- test/rust --update-mode override
```

## Without flakes

```shellSession
bash $(nix-build -A <template_name>) <output_directory> <args>
```

Similarly to the example above, you can generate a Rust template with:

```shellSession
bash $(nix-build -A rust) test/rust --update-mode override
```
