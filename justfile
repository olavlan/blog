# list all available commands
default:
    @just --list


# builds blog.json with all posts converted to JSON-serialized pandoc AST
build:
    #!/bin/sh
    for file in posts/*; do
        name="$(basename "$file")"
        date="$(date -r "$file" +"%Y-%m-%d")"
        pandoc_json="$(pandoc "$file" -t json)" || continue
        echo "$pandoc_json" | jq --arg name "$name" --arg date "$date" '{($name): {date_created: $date, pandoc: .}}'
    done | jq -s 'add' > blog.json
