#!/bin/bash

# Get script name & path.
#SN=${0##*/}
#SP=${0%/*}
#me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

DIR=`pwd`
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
BUNDLE_GEMFILE=$SCRIPTPATH/Gemfile
cd $SCRIPTPATH
bundle install --path ./vendor/bundle
cd $DIR
