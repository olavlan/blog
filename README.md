# Blog

Blog posts converted to JSON-serialized Pandoc AST, served as static files.

## Build

```sh
just build
```

This reads every file in `posts/` and writes a `blog.json` with metadata and inline pandoc AST for all posts.

## Git hook

To ensure built files are always up to date in the repo, add a pre-commit hook:

```sh
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/sh
just build
git add blog.json
EOF
chmod +x .git/hooks/pre-commit
```

This runs `just build` and stages the output before every commit. The commit is aborted if the build fails.