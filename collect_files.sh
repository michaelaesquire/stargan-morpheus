##!/bin/bash
## for putting all of the pngs from different images into one directory together
# directory containing subfolders -- change this to whatever you need it to be
cd /Users/molson02/Documents/Microscope_Images/mm_07302019/Untreated/aspng
# create a subdirectory
mkdir allpng
#mm_07302019 isthere right now as an example, write something that is at the beginning of
# your folder names
for f in mm_07302019*/*.png; do cp "$f" allpng/; done
