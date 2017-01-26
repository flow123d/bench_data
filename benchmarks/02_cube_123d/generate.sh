#!/bin/bash

#
#  Script for preparation of input data for weak scaling tests.
#
#
#set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

if [[ -z $1 ]]; then
    cpus="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16"
else
    cpus=$@
fi

"../../bin/generate.sh" -g cube_123d.geo -d 3 -- $cpus