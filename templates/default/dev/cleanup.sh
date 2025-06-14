#!/bin/env bash

declare -A replacements=(
    # "!{{name}}!" = "world"; -> hello = "world";
    # "!./hello.nix!" -> ./hello.nix
    ["\" ="]=" ="
    ["\"!"]=""
    ["!\""]=""

    # `#! overlays = [ ];` -> ` overlays = [ ];`
    ["#!"]=""
)

declare -A deletions=(
    # delete entire line
    ["##"]=""
)

sed_command=""

escape_token() {
    printf '%s\n' "$1" | sed 's/[\/&]/\\&/g'
}

for token in "${!replacements[@]}"; do
    sed_command+="s/$(escape_token "$token")/$(escape_token "${replacements[$token]}")/g; "
done

for token in "${!deletions[@]}"; do
    sed_command+="/^.*$(escape_token "$token").*$/d; "
done

fd --type f -x sed -i -e "$sed_command" {}
