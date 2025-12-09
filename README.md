
# digikata.github.io Readme

[digikata.github.io](https://digikata.github.io)

## Branch Notes
* master: site content and generation config
* pub: branch w/ docs directory output for github service

## Dir/File Notes
* pub/docs: served by github static pages config

## Github static file publishing

zola publish -o pub/site

pub/site in the digikata workspace is setup to point to
  https://github.com/digikata/digikata.github.io

That repo is setup to serve github static pages from main

## Changes
2025-12-09 update to zola 0.21.0, change theme, change blog impl


Cloudflare analystics are staring to work
https://dash.cloudflare.com/78bb465d2de81a08f857a8f8adfe8077/web-analytics/sites