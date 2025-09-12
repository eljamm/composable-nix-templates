# Description

This project presents a more flexible alternative to using flake templates (which is just a fancy way to `cp -r`).<br>
By leveraging the [ffizer](https://github.com/ffizer/ffizer) scaffolding tool, you'll be able to create updateable templates with custom parameters and composable files.

<!-- `$ tree -L 4 --noreport --dirsfirst templates/` as shellSession -->

```shellSession
templates/
├── default
│   ├── nix
│   │   ├── utils
│   │   │   ├── import-flake.nix
│   │   │   └── saveFromGC.nix
│   │   ├── cleanup.sh
│   │   ├── formatter.ffizer.hbs.nix
│   │   └── lib.ffizer.hbs.nix
│   ├── default.ffizer.hbs.nix
│   └── flake.ffizer.hbs.nix
├── go
│   ├── _default -> ../default
│   └── nix
│       └── {{template_name}}.ffizer.hbs.nix
├── rust
│   ├── _default -> ../default
│   ├── nix
│   │   ├── crates
│   │   │   ├── default.nix
│   │   │   └── hello.nix
│   │   └── {{template_name}}.ffizer.hbs.nix
│   ├── src
│   │   └── main.rs
│   ├── Cargo.lock
│   └── Cargo.toml
└── zig
    ├── _default -> ../default
    └── nix
        └── {{template_name}}.ffizer.hbs.nix
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

- [x] Refactor templates to use default.nix
- [ ] CI/CD workflows
  - [ ] template verification
  - [ ] process documentation
- [ ] Improve documentation
