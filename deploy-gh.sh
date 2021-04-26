#!/bin/sh
git add .
git commit -m "update blog sources"
hugo
cp -rf docs/* ../qdriven.github.io
rm -rf docs/
cd ../qdriven.github.io
git add .
git commit -m "update latest blog"
git push -u origin master