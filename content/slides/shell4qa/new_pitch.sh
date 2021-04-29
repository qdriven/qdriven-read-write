#!/bin/sh
git stash
git checkout master
git pull
BRANCH_NAME=$1
git checkout -b ${BRANCH_NAME}