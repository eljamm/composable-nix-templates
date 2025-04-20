# Description

Compose nix templates using [ffizer](https://github.com/ffizer/ffizer).

| Templates |
|-----------|
| rust      |
| go        |
| basic     |

# Usage

## Without flakes

```shellSession
bash $(nix-build -A <template_name>) <output_directory> <args>
```

Examples:

```shellSession
bash $(nix-build -A rust) test/rust --update-mode override
```

## Flakes

```shellSession
nix run .#<template_name> -- <output_directory> <args>
```

Examples:

```shellSession
# Try without installing
nix run github:eljamm/nix-templates#rust -- test/rust --update-mode override

nix run .#rust -- test/rust --update-mode override
```
