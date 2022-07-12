#!/bin/bash

if [ ! -f "$0" ];
then
  echo "ERROR: $0 is not a file"
fi

folder=$(dirname "$0")
file=$(basename "$0")

echo ">> Weaving $file in $folder"
julia --project -e "using JSOTutorials; JSOTutorials.weave_file($folder, $file)"

# git clone https://github.com/JSOTemp/JSOTemp.github.io
