
Assemblr for Flickr
===================

This app downloads images from Flickr and combines them into an image grid.


Prerequisites
-------------

1. Ruby v2.1+
2. ImageMagick
3. one of Wordlist packages (Linux), or another dictionary (text file, one word per line)

Make sure you have the dictionary file `/usr/share/dict/words`:

    # ls -lah /usr/share/dict/

If not, install a wordlist package:

    # Ubuntu/Debian:
    $ sudo apt-get install wordlist

Make sure you have ImageMagick installed:

    # Check if imagemagick's `convert` is installed:
    $ which convert

OSX:

    # Install package from http://cactuslab.com/imagemagick/
    # OR
    # use brew:
    $ brew install imagemagick

Ubuntu:

    $ sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev


Installation
------------

This will install all the gems needed into `<app_directory>/vendor/gems`:

    $ gem install bundler
    $ cd <app_directory>
    $ ./install.sh

Note: Repeat these steps if you change/upgrade your ruby interpreter.


How to run
----------

Flickr API key and secret must be provided.

You can set them via environment variables

    $ export FLICKR_API_KEY=your_key
    $ export FLICKR_API_SECRET=your_secret

or via the command line arguments:

    $ bin/assemblr --total 15 --flickr-api-key <key> --flickr-api-secret <secret> -o picture.jpg

More examples:

    # Fetch by specific keywords
    $ bin/assemblr --total 10 --keywords "old oak",clock,headphones --out-file picture.jpg

    # Set jpeg compression level (quality of the output file):
    $ bin/assemblr --jpeg-quality 10 --out-file picture.jpg

    # Increase picture size by setting height of rows
    $ bin/assemblr --row-height=600 -o picture.jpg

More options:

    $ bin/assemblr -h

Have fun!


TODO LIST:
----------

* Write specs.
* Make 8px alignment functional.
* Calculate number of rows if `--rows auto` argument is given.
* Extract ::CoreExt classes to a gem.

