#!/bin/bash

#Given an input .task file alter the tags per input from commandline. Meant to be ultimately called from neovim via keybinding when "task edit" called and opened in neovim.

taskfile="$1"
tag="$2"

if [[ -z $taskfile || ! -s "$taskfile" || -z tag ]]; then
  echo "You must supply a taskfile path and tag"
  echo "Usage:"
  echo "taskw_toggle_tag.sh path_to_taskfile <tag>"
  exit 1
fi

already_present_check=$(grep -P "^\s*Tags:.*\b$tag\b" "$taskfile")
if [[ -z $already_present_check ]]; then #Tag is not already_present_check
  echo "Adding tag"
  sed -i -r "s/^([[:space:]]*Tags:.*)/\1 $tag/" "$taskfile"
else
  echo "Removing tag"
  sed -i -r "s/^([[:space:]]*Tags:.*)($tag)(.*)/\1 \3/" "$taskfile"
fi
