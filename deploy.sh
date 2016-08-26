#!/bin/bash
set -e

echo "# set git environment"
git config user.email "iamstarkov@gmail.com"
git config user.name "Vladimir Starkov"
git remote rm origin
git remote add origin https://iamstarkov:${GITHUB_TOKEN}@github.com/iamstarkov/fp-js-workshop.git

echo "# clean"
rm -rf dist

echo "# build"
mkdir dist

echo "# build 01-theoretic-intro"
mkdir dist/01-theoretic-intro
cleaver 01-theoretic-intro.md --output dist/01-theoretic-intro/index.html

echo "# build 02-practical-intro"
mkdir dist/02-practical-intro
cleaver 02-practical-intro.md --output dist/02-practical-intro/index.html

echo "# deploy dist to gh-pages"
buildbranch gh-pages dist
