# Description

This project presents a more flexible alternative to using flake templates (which is just a fancy way to `cp -r`).<br>
By leveraging the [ffizer](https://github.com/ffizer/ffizer) scaffolding tool, you'll be able to create updateable templates with custom parameters and composable files.

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
├── default
│   ├── dev
│   │   ├── cleanup.sh
│   │   └── formatter.ffizer.hbs.nix
│   ├── default.ffizer.hbs.nix
│   └── flake.ffizer.hbs.nix
├── go
│   ├── _default -> ../default
│   └── dev
│       └── {{template_name}}.ffizer.hbs.nix
└── rust
    ├── _default -> ../default
    ├── dev
    │   ├── crates
    │   │   ├── default.nix
    │   │   └── hello.nix
    │   └── {{template_name}}.ffizer.hbs.nix
    ├── src
    │   └── main.rs
    ├── Cargo.lock
    └── Cargo.toml
```

For more details regarding the templating sytax and command-line arguments used throughout this project, check out [ffizer's documentation](https://ffizer.github.io/ffizer/book/overview.html).

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

# TODO

- [ ] CI/CD workflows
  - [ ] template verification
  - [ ] process documentation
- [ ] Refactor templates
- [ ] Improve documentation
