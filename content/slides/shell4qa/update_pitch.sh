#! /bin/sh

COMMENT=$1

git add .
git commit -m "${COMMENT}"

CRRENT_BRANCH=`git branch --show-current`
git push origin ${CURRENT_BRANCH}

git checkout master
git merge ${CRRENT_BRANCH}
echo "- [{COMMENTS}](http://gitpitch.com/allroundtesters/allroundtester.git.io/${CURRENT_BRANCH})"  >> README.md
git add .
git commit -m "${COMMENT}"
git push