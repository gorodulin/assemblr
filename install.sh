#!/bin/bash

realpath() { # OS X dirty replacement.
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

DIR=`pwd`
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
BUNDLE_GEMFILE=$SCRIPTPATH/Gemfile
cd $SCRIPTPATH
bundle install --path ./vendor/bundle
cd $DIR
