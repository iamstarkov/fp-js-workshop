#!/bin/bash
set -e

echo "# set git environment"
git config user.email "iamstarkov@gmail.com"
git config user.name "Vladimir Starkov"
git remote rm origin
git remote add origin https://iamstarkov:${GITHUB_TOKEN}@github.com/iamstarkov/fp-js-workshop.git
# git checkout master

echo "# clean"
rm -rf dist

echo "# build"
mkdir dist
# ls -al dist

echo "# build 01-theoretic-intro"
mkdir dist/01-theoretic-intro
# ls -al dist
cleaver 01-theoretic-intro.md --output dist/01-theoretic-intro/index.html
# ls -al dist/01-theoretic-intro

echo "# deploy dist to gh-pages"
buildbranch gh-pages dist
