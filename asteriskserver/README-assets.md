## How to create assets

run:

```
make audio
```

This will create normalized audio assets in the DEST dir pointed to in the makefile.
It simply copies mp3s, no normalization happens for those files.

## Hot to delete generated assets

run:
```
make clean
```

## Requirements:

* *make*
* *ruby*
* *ruby-dev*
* ruby gems:
  *sndfile*
* *sndfile-programs*

```
sudo apt-get install ruby ruby-dev libsndfile-dev make sndfile-programs libgsl-dev
gem install --user sndfile
```
