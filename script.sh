#!/bin/bash

date_to_timestamp() {
    local TIMESTAMP=$(date -d "$1" +%s)

    echo $TIMESTAMP
}

TODAY=$(date +"%Y-%m-%d")

START_DATE="${TODAY}T00:00:00"
END_DATE="${TODAY}T23:59:59"

NEW_START_DATE="${TODAY}T08:30:00"
NEW_END_DATE="${TODAY}T17:30:00"

START_TIMESTAMP=$(date_to_timestamp $START_DATE)
END_TIMESTAMP=$(date_to_timestamp $END_DATE)
NEW_START_TIMESTAMP=$(date_to_timestamp $NEW_START_DATE)
NEW_END_TIMESTAMP=$(date_to_timestamp $NEW_END_DATE)

NEW_INTERVAL=$((NEW_END_TIMESTAMP - NEW_START_TIMESTAMP))

git filter-branch --env-filter '
    if [ $GIT_COMMITER_DATE -ge $START_TIMESTAMP ] && [ $GIT_COMMITER_DATE -le $END_TIMESTAMP]; then
        export GIT_COMMITER_DATE="2024-05-03T17:00:00"
        export GIT_AUTHOR_DATE="2024-05-03T17:00:00"
    fi
' --tag-name-filter cat -- --all