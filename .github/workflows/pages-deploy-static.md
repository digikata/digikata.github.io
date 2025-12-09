name: Publish static site to GitHub Pages

on:
  push:
    branches:
      - pub
  workflow_dispatch:

permissions:
  pages: write
  contents: read
  id-token: write

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Verify pub/site exists
        run: |
          if [ ! -d "pub/site" ]; then
            echo "::error::pub/site directory not found. Nothing to publish."
            echo "Workspace contents:"
            ls -la
            exit 1
          fi

      - name: Ensure no Jekyll in pub/site
        run: |
          # create .nojekyll so Pages won't run Jekyll on the artifact
          touch pub/site/.nojekyll

      - name: Upload site artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: pub/site

      - name: Deploy to GitHub Pages
        uses: actions/deploy-pages@v1