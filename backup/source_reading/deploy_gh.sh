#!/usr/bin/env bash


echo "commit message is "$1
python index_generator.py

git add .
git commit -m "$1"
git push

source bin/activate
pip install -r requirements.txt
mkdocs gh-deploy --clean
