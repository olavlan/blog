# Blog

Blog posts converted to JSON-serialized Pandoc AST, served as static files.

## Build

```sh
just build
```

This reads every file in `posts/` and writes the corresponding JSON to `dist/`, plus an `index.json` with metadata for all posts.

## Git hook

To ensure built files are always up to date in the repo, add a pre-commit hook:

```sh
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
just build
git add dist/ index.json
EOF
chmod +x .git/hooks/pre-commit
```

This runs `just build` and stages the output before every commit. The commit is aborted if the build fails.