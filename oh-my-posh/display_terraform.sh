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

if find_file ".terraform-version" > /dev/null; then
  terraform --version 2>/dev/null | head -n1 | awk '{print $2}'
fi
