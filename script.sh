#!/bin/bash

# Configurações iniciais
TODAY=$(date +"%Y-%m-%d")
START_DATE="${TODAY}T00:00:00"
END_DATE="${TODAY}T23:59:59"
NEW_START_DATE="2023-01-01T00:00:00"
NEW_END_DATE="2023-12-31T23:59:59"

# Converte datas para timestamps
START_TIMESTAMP=$(date -d "$START_DATE" +%s)
END_TIMESTAMP=$(date -d "$END_DATE" +%s)
NEW_START_TIMESTAMP=$(date -d "$NEW_START_DATE" +%s)
NEW_END_TIMESTAMP=$(date -d "$NEW_END_DATE" +%s)

# Calcula a diferença de tempo entre as novas datas
NEW_INTERVAL=$((NEW_END_TIMESTAMP - NEW_START_TIMESTAMP))

# Calcula a diferença de tempo entre as datas originais
ORIGINAL_INTERVAL=$((END_TIMESTAMP - START_TIMESTAMP))

# Função para calcular nova data
calculate_new_date() {
    local original_date=$1
    local original_timestamp=$(date -d "$original_date" +%s)
    local position=$((original_timestamp - START_TIMESTAMP))
    local ratio=$(awk "BEGIN {print $position / $ORIGINAL_INTERVAL}")
    local new_position=$(awk "BEGIN {print int($ratio * $NEW_INTERVAL)}")
    local new_timestamp=$((NEW_START_TIMESTAMP + new_position))
    date -d "@$new_timestamp" +"%Y-%m-%dT%H:%M:%S"
}

# Filtra os commits e ajusta as datas
git filter-branch --env-filter '
START_TIMESTAMP=$(date -d "'$START_DATE'" +%s)
END_TIMESTAMP=$(date -d "'$END_DATE'" +%s)
new_date=$(calculate_new_date $(date -d @$GIT_COMMITTER_DATE +"%Y-%m-%dT%H:%M:%S"))
export GIT_COMMITTER_DATE="$new_date"
export GIT_AUTHOR_DATE="$new_date"
' --tag-name-filter cat -- --all

# Remove o backup criado pelo filter-branch
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now
