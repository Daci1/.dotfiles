#!/bin/bash

find_file() {
  file_name="$1"
  dir="$(pwd)"

  while [ "$dir" != "/" ] && [ -n "$dir" ]; do
    if [ -f "$dir/$file_name" ]; then
      echo "$dir/$file_name"
      return 0
    fi
    dir="$(dirname "$dir")"
  done

  return 1
}

nvmrc_path=$(find_file ".nvmrc")
pkg_path=$(find_file "package.json")

if [ -n "$nvmrc_path" ] || [ -n "$pkg_path" ]; then
  node --version 2>/dev/null
fi

