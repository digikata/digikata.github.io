
_default :
	just --list

# publish merge master to pub branch, regen docs, commit and push
publish: gen
	#!/bin/sh
	# tag the publish at the top level repo
	# with pub-yyyy-mm-dd-N (with the first publish w/o the -N, and following)
	git tag $(just next-tag) -m "publish"
	git push --tags

	# push to digikata.github.io publish site
	# pub/site is a repo setup to point to digikata.github.io repo
	cd pub/site
	git add .
	git commit -m "publish from master"
	git push -f origin HEAD:main

# generate pages
gen :
	# github pages will only serve a subfolder with the option of docs
	# odd but whatever
	zola build -f -o branch/pub
	echo digikata.com > branch/pub/CNAME

# output zola-serve.log, assuming using local check
log:
	tail -n 20 zola-server.log

# utility tgt
next-tag:
	./scripts/git-next-tag.sh

# serve local check
serve :
	# Zola serve will create a temporary ./public directory
	# the -u rewrites base url from the specced digikata.com
	# otherwise the css fetches fail
	zola serve \
		--base-url http://127.0.0.1 \
		2>&1 | tee zola-serve.log

# setup branch pub target
setup:
	#!/bin/sh
	mkdir -p branch
	cd branch
	git clone .. ./pub --branch main

