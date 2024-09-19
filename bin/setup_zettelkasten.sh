#!/bin/bash

root_dir=$1

if [[ -z $root_dir ]]; then
  echo "You must supply a root directory path (will be created)"
  exit 1
fi

mkdir -p "$root_dir"
cd "$root_dir"
mkdir -p 0-inbox
mkdir -p 00-zettelkasten
mkdir -p 1-projects
mkdir -p 2-areas
mkdir -p 3-resources
mkdir -p 4-archive
mkdir -p 5-journal
mkdir -p templates
mkdir -p hub

if [[ ! -s $root_dir/templates/note.md ]]; then
  echo "Creating note template $root_dir/templates/note.md"
  cat <<EOF >$root_dir/templates/note.md
---
date: {{date}}
tags:
  -
hubs:
  - "[[]]"
urls:
  -
---

# {{title}}
EOF
else
  echo "Note template already exists"
fi
