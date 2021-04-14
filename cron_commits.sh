#!/usr/bin/env bash

set -e

# Usage: ./cron_commits.sh <owner/repo> <cache_file> <bool>
# Calls ./generate.sh after finding new commits to <owner/repo>

touch $2

most_recent=$(cat $2)

commits=$(curl -s https://api.github.com/repos/$1/commits)
sha=$(echo "$commits" | jq -r '.[0].sha')

if [ -z "$most_recent" ]
then
    printf "$sha" > $2
    most_recent="$sha"
    echo "first run of loop, commit is $sha"
    exit
fi

if [ "$most_recent" == "$sha" ]
then
    echo "most recent commit is the same, sleeping"
    exit
fi

echo "found new commit $sha"
./generate.sh

if [ "$3" == "true" ]
then
    $(dirname $(realpath $0))/commit.sh
fi
