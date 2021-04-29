#!/bin/sh

CONTENT=`cat $1`
echo $CONTENT
TITLE=$2
echo $TITLE
gh issue create -t "$TITLE" --body "$CONTENT" -l tips