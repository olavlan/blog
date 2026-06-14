# list all available commands
default:
    @just --list


build:
    #!/bin/sh
    echo "Building posts.json..."
    for file in posts/*; do
        name="$(basename "$file")"
        date="$(date -r "$file" +"%Y-%m-%d")"
        pandoc_json="$(pandoc "$file" -t json)" || continue
        echo "$pandoc_json" | jq --arg name "$name" --arg date "$date" '{($name): {date_created: $date, pandoc: .}}'
    done | jq -s 'add' > posts.json


install-hook:
    printf '#!/usr/bin/env sh\nset -e\njust build\ngit add -A\n' > .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
