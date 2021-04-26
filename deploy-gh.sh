#!/bin/sh
git add .
git commit -m "update blog sources"
hugo
mv docs/* ../qdriven.github.io
cd ../qdriven.github.io
git add .
git commit -m "update latest blog"
git push -u origin master