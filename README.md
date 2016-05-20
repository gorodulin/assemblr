Assemblr for Flickr
===================

This app downloads images from Flickr and combines them into an image grid.

Installation
------------

    $ cd <app_directory>
    $ ./install.sh

How to run
----------

Flickr API key and secret must be provided.

You can set them via env variables

    $ export FLICKR_API_KEY=your_key
    $ export FLICKR_API_SECRET=your_secret

or via command line arguments:

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
