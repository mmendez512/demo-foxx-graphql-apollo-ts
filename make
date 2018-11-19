#!/bin/bash

set -eu
set -o pipefail

# Use this script base dir name and the project name
PRJ_PATH="`dirname \"${BASH_SOURCE[0]}\"`"
PRJ_PATH="`( cd -P \"$PRJ_PATH\" && pwd )`"
PRJ_NAME="`basename $PRJ_PATH`"

cd $PRJ_PATH
echo cd: \'`pwd`\'

if [[ ! -d dist/$PRJ_NAME ]]; then
  mkdir -vp "dist/$PRJ_NAME";
fi

echo

# Compile ts files to js
npx --no-install tsc --listEmittedFiles

echo

(cd approot
 echo cd: \'`pwd`\'
 cp -vr --parents -t "../dist/$PRJ_NAME/" *)

echo

(cd build
 echo cd: \'`pwd`\'
 find * -name "*.js" -exec cp -v --parents -t "../dist/$PRJ_NAME/" "{}" +)

echo

(cd src
 echo cd: \'`pwd`\'
 find * -name "*.graphql" -exec cp -v --parents -t "../dist/$PRJ_NAME/" "{}" +)

echo

(cd approot
 echo cd: \'`pwd`\'
 cp -vr --parents -t "../dist/$PRJ_NAME/" *)

echo

(cd dist/$PRJ_NAME
 echo cd: \'`pwd`\'
 npm i)

echo

(cd dist
 echo cd: \'`pwd`\'
 zip -r "$PRJ_NAME" "$PRJ_NAME"
 echo "'dist/$PRJ_NAME.zip' created.")
