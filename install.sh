#!/bin/bash

DIR=`pwd`
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
BUNDLE_GEMFILE=$SCRIPTPATH/Gemfile
cd $SCRIPTPATH
bundle install --path ./vendor/bundle
cd $DIR
