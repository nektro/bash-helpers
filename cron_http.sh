#!/usr/bin/env bash

# Usage: ./cron_http.sh <url> <cache_file> <bool>
# Calls ./generate.sh after finding new updates to <url>

touch $2

most_recent=$(cat $2)

headers=$(curl -s -X HEAD -v $1 2>&1)
etag=$(echo "$headers" | grep 'etag')

if [ -z "$most_recent" ]
then
    printf "$etag" > $2
    most_recent="$etag"
    echo "first run of loop, $etag"
    exit
fi

if [ "$most_recent" == "$etag" ]
then
    echo "most recent etag is the same, sleeping"
    exit
fi

echo "found new $etag"
./generate.sh

if [ -z "$3" ]
then
    exit
fi

$(dirname $(realpath $0))/commit.sh
