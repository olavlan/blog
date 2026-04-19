base_url := "https://raw.githubusercontent.com/olavlan/blog/refs/heads/master"

# builds dist/ with all posts converted to JSON-serialized pandoc AST, plus an index file
build:
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p dist
    entries=()
    for file in posts/*; do
        [ -f "$file" ] || continue
        name="$(basename "$file" | sed 's/\.[^.]*$//')"
        temp="$(echo "$name" | tr '-' ' ')"
        title="${temp^}"
        date_created="$(date -d "$(stat --format='%w' "$file")" +"%Y-%m-%dT%H:%M:%S%:z")"
        json_path="dist/${name}.json"
        pandoc "$file" -t json -o "$json_path"
        entries+=("{\"date_created\":\"$date_created\",\"title\":\"$title\",\"url\":\"{{base_url}}/$json_path\"}")
    done
    index="$(IFS=,; echo "[${entries[*]}]")"
    echo "$index" | jq '.' > index.json
