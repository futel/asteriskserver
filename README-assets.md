# Audio assets

Note: these steps are for reference only, all of the actions should be performed by the build/deploy steps. This should be verified, and then this cdocument can be removed. Probably the only things remaining are cleaning and requirements.

We want to normalize audio for the maximum volume and get it into a format the asterisk can read.

See [audio formats](https://wiki.asterisk.org/wiki/display/AST/Asterisk+10+Codecs+and+Audio+Formats)

## How to generate assets

run:

```
make audio
```

This will create normalized audio assets in the DEST dir pointed to in the makefile.
It simply copies mp3s, no normalization happens for those files.

## How to delete generated assets

run:

```
make clean
```

## Requirements:

* make
* ruby
  * ruby gems:
    * sndfile
      * requires
        * libgsl-dev
        * libsndfile-dev
        * ruby-dev
* sndfile-mix-to-mono
* normalize-audio

```
sudo apt-get install ruby ruby-dev libsndfile-dev make sndfile-programs libgsl-dev normalize-audio
gem install --user sndfile
```
