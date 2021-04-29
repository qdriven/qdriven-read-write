#! /bin/sh

echo "current working folder:"`pwd`
remotes=`git remote`

for R in $remotes; 
do
  echo "start to commit to $R"
  git add .
  git commit -m '$1'
  git push $R master
done

