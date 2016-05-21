
Assemblr for Flickr
===================

This app downloads images from Flickr and combines them into an image grid.


Prerequisites
-------------

1. Ruby v2.1+
2. ImageMagick
3. one of Wordlist packages (Linux), or another dictionary (text file, one word per line)


Installation
------------

This will install all the gems required into the `<app_directory>/vendor/bundle` folder:

    $ gem install bundler
    $ cd <app_directory>
    $ ./install.sh

Note: Repeat these steps if you have switched/upgraded your ruby interpreter.


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


Troubleshooting
---------------

**ERROR: No such file or directory @ rb_sysopen - /usr/share/dict/words**

Make sure you have the dictionary file `/usr/share/dict/words`:

    # ls -lah /usr/share/dict/

If not, install a wordlist package:

    # Ubuntu/Debian:
    $ sudo apt-get install wordlist


**How to install ImageMagick**

    # Check if imagemagick is installed:
    $ which convert

OSX:

    # Install package from http://cactuslab.com/imagemagick/
    # OR
    # use brew:
    $ brew install imagemagick

Ubuntu:

    $ sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev


TODO LIST:
----------

* Write specs.
* Make 8px alignment work as intended.
* Auto-adjust number of rows if `--rows auto`.
* Extract ::CoreExt classes into a gem.

