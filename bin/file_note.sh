#!/bin/bash

fq_note=$1
z_root=$2

if [[ "$2" == "-d" ]]; then
  rm "$1"
  if [[ $? -ne 0 ]]; then
    echo "Failed to delete file"
    exit 1
  else
    exit 0
  fi
fi

#Not asked to delete, so moving on to file the note

if [[ -z $fq_note ]]; then
  echo "You must supply a note path"
  echo "Usage:"
  echo "file_note.sh path_to_note zettelkasten_root_dir"
  exit 1

fi

hub_name=$(grep -A1 '^hubs:' $fq_note | sed -z 's/\n/ /g' | sed -r 's/^hubs:.*\[\[(.*)\]\].*/\1/' | xargs -I {} printf "%s\n" "{}" | sed 's/ /-/g')
new_dir="$z_root/00-zettelkasten/$hub_name"
mkdir -p "$new_dir"
touch "$new_dir/${hub_name}.md"
mv $fq_note ${new_dir}/
if [[ $? -ne 0 ]]; then
  echo "Failed to file note."
fi
