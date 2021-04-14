#!/usr/bin/env bash

set -e

# Usage: ./commit.sh [anything to add to commit message]

git fetch
git pull
git add .
git commit "nektro/bash-helpers: run ./generate.sh"
git push origin $(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
