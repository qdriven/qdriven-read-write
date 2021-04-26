#!/usr/bin/env bash

TITLE=$1
LABEL="tips"
FILE_PATH=$2
echo "cat ${FILE_PATH}"
content=`cat ${FILE_PATH}`
echo $content
gh issue create --title "${TITLE}" --label "${LABEL}" --body "${content}"