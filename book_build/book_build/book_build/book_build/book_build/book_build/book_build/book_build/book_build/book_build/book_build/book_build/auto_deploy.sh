#! /bim/bash

gitbook build
cp -r _book/* book_build
cd book_build
git add .
git commit -m "two sum"
git push origin gh-pages
