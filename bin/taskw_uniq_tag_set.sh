#!/bin/bash

set -u
DEBUG=false

$DEBUG && mkdir -p ~/.cache

#Given an input .task file alter the tag to zero or one from a unique list. Meant to be ultimately called from neovim via keybinding when "task edit" called and opened in neovim.

uniq_tag_list_str="INCIDENT,NUCLEUS_INC,TRAINING,EMAIL_SUPPORT,SCRIPTING,CUST_MEETING,TCS_MEETING,CRQ,MISC,W_O_REQ,PTO"

taskfile=
if [[ $# -gt 0 ]]; then
  taskfile="$1"
fi
taskfile="$1"
tag=
if [[ $# -gt 1 ]]; then
  tag="$2"
fi

if [[ -z $taskfile || ! -s "$taskfile" ]]; then
  echo "You must supply a taskfile path and tag"
  echo "Usage:"
  echo "taskw_toggle_tag.sh path_to_taskfile <tag>"
  exit 1
fi

IFS=', ' read -r -a uniq_tag_list <<<"$uniq_tag_list_str"
tag_in_list_ck=$(echo "${uniq_tag_list[@]}" | grep -Po "\b$tag\b")
if [[ ! -z $tag && -z $tag_in_list_ck ]]; then
  echo "$tag is not valid tag in the chosen tag list: ${uniq_tag_list[@]}."
  exit 1
fi

tag_line=$(grep -P "^\s*Tags:" "$taskfile")
pre=$(echo "$tag_line" | sed -r "s/^([[:space:]]*Tags:[[:space:]]*)(.*$)/\1/")
tags=$(echo "$tag_line" | sed -r "s/^([[:space:]]*Tags:[[:space:]]*)(.*)$/\2/")
for itag in "${uniq_tag_list[@]}"; do
  $DEBUG && echo "tags before remove *$tags*" >>/home/jason/.cache/set_uniq_tag.log
  tags=$(echo "$tags" | sed -r -e "s/$itag//" -e 's/  / /g' -e 's/[[:space:]]$//' -e 's/^[[:space:]]//')
  $DEBUG && echo "tags after remove *$tags*" >>/home/jason/.cache/set_uniq_tag.log
done

if [[ ! -z $tags ]]; then
  tags="$tags "
fi
tags="${tags}${tag}"

$DEBUG && echo "Running sed -i -r \"s/^[[:space:]]*Tags:.*$/${pre}${tags}/\"" >>~/.cache/set_uniq_tag.log
sed -i -r "s/^[[:space:]]*Tags:.*$/${pre}${tags}/" "$taskfile"
