# builds blog.json with all posts converted to JSON-serialized pandoc AST
build:
    #!/usr/bin/env bash
    set -euo pipefail
    schema_url="https://raw.githubusercontent.com/olavlan/blog/refs/heads/master/blog.schema.json"
    entries=()
    for file in posts/*; do
        [ -f "$file" ] || continue
        name="$(basename "$file" | sed 's/\.[^.]*$//')"
        temp="$(echo "$name" | tr '-' ' ')"
        title="${temp^}"
        date_created="$(date -d "$(stat --format='%w' "$file")" +"%Y-%m-%dT%H:%M:%S%:z")"
        pandoc_json="$(pandoc "$file" -t json)"
        entry="$(jq -n --arg date_created "$date_created" --arg title "$title" --argjson pandoc "$pandoc_json" '{date_created: $date_created, title: $title, pandoc: $pandoc}')"
        entries+=("$entry")
    done
    jq -n --arg schema "$schema_url" --argjson posts "$(jq -s '.' <(printf '%s\n' "${entries[@]}"))" '{"$schema": $schema, posts: $posts}' > blog.json