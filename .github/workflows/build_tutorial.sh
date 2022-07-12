#!/bin/bash

ARG=$1
if [ ! -f "$ARG" ];
then
  echo "ERROR: $ARG is not a file"
fi

folder=$(dirname "$ARG")
file=$(basename "$ARG")

echo ">> Weaving $file in $folder"
julia --project -e "using Pkg; Pkg.instantiate(); using JSOTutorials; JSOTutorials.weave_file(\"$folder\", \"$file\")"

# git clone https://github.com/JSOTemp/JSOTemp.github.io
