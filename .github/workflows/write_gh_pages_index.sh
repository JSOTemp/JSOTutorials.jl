#!/bin/bash

shopt -s globstar

echo "# Tutorial list

Check the website for a better formatted version: <https://juliasmoothoptimizers.github.io>.
" > index.md

for file in **/*.md
do
  if [ "$file" == "index.md" ]; then
    continue
  fi
  d=$(dirname $file)
  echo "- [$d]($d)"
done >> index.md
