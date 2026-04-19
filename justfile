base_url := "https://example.com/blog"

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
        entries+=("$(jq -n --arg dc "$date_created" --arg t "$title" --arg u "{{base_url}}/$json_path" '{date_created: $dc, title: $t, url: $u}')")
    done
    printf '%s\n' "${entries[@]}" | jq -s '.' > index.json
