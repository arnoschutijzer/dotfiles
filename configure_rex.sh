#!/bin/zsh
# Link Rex configuration without replacing an existing file, directory, or link.
set -eu

repo="${0:A:h}"
source_dir="$repo/configuration/rex"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
destination="$config_home/rex"

if [[ -L "$destination" && "$(readlink "$destination")" == "$source_dir" ]]; then
  print -r -- "Rex configuration already linked: $destination"
elif [[ -e "$destination" || -L "$destination" ]]; then
  print -u2 -r -- "Skipping existing Rex configuration: $destination"
else
  mkdir -p "$config_home"
  ln -s "$source_dir" "$destination"
  print -r -- "Linked Rex configuration: $destination"
fi
