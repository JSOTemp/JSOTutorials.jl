#!/bin/bash

FILE=$1
if [ ! -f "$FILE" ];
then
  echo "ERROR: $FILE is not a file"
  return
fi

folder=$(dirname "$FILE")
file=$(basename "$FILE")

folder_without_tutorial_prefix=$(echo $folder | cut -d'/' -f2-)
file_change_suffix=$(basename -s .jmd $file).md
OUTPUT_FILE=parsed/$folder_without_tutorial_prefix/$file_change_suffix
mkdir -p $(dirname $OUTPUT_FILE)

echo ">> Weaving $file in $folder"
julia --project -e """
using Pkg;
Pkg.instantiate();
using JSOTutorials;
folder = split(\"$folder\", \"/\")[2:end] # to remove tutorials prefix;
folder = join(folder, \"/\");
JSOTutorials.weave_file(folder, \"$file\")
"""

tags="[]"
yaml_count=0
while read -r line
do
  if [[ "$line" == "---" ]]; then
    yaml_count=$(($yaml_count + 1))
    if [ $yaml_count == 2 ]; then
      break
    fi
    continue
  fi
  KEY=$(echo $line | awk -F': ' '{ print $1 }')
  VALUE=$(echo $line | awk -F': ' '{ print $2 }')
  printf -v "$KEY" "%s" "$VALUE"
done < $FILE

echo """@def title = \"$title\"
@def showall = true
@def tags = $tags

\preamble{$author}
""" > $OUTPUT_FILE

yaml_count=0
while read -r line
do
  if [[ "$line" == "---" ]]; then
    yaml_count=$(($yaml_count + 1))
    continue
  fi
  if [ $yaml_count == 2 ]; then
    echo $line >> $OUTPUT_FILE
  fi
done < $FILE
