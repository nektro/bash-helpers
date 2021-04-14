#!/usr/bin/env bash

# Usage: ./cron_http.sh <url> <wait in hrs> <bool>
# Calls ./generate.sh after finding new updates to <url>

most_recent=''

while true
do
    headers=$(curl -s -X HEAD -v $1 2>&1)
    etag=$(echo "$headers" | grep 'etag')

    if [ -z "$most_recent" ]
    then
        most_recent="$etag"
        echo "first run of loop, $etag"
        continue
    fi

    if [ "$most_recent" == "$etag" ]
    then
        echo "most recent etag is the same, sleeping"
        # sec - min - hr
        sleep $((1 * 60 * 60 * $2))
        continue
    fi

    echo "found new $etag"
    ./generate.sh

    if [ "$3" == "true" ]
    then
        $(dirname $(realpath $0))/commit.sh
    fi
done
