
_default :
	just --list

# publish merge master to pub branch, regen docs, commit and push
publish: gen
	#
	# pub/site is a repo setup to point to
	cd pub/site && git add .
	-cd pub && git commit -m "publish from master"
	-cd pub && git push -f origin HEAD:main
	# resync pub branch to this repo
	git fetch
	# TODO: tag the publish at the top level repo


# generate pages
gen :
	# github pages will only serve a subfolder with the option of docs
	# odd but whatever
	zola build -f -o pub/site/
	echo digikata.com > pub/site/CNAME

# serve local check
serve :
	# Zola serve will create a temporary ./public directory
	# the -u rewrites base url from the specced digikata.com
	# otherwise the css fetches fail
	zola serve \
		--base-url http://127.0.0.1 \
		2>&1 | tee zola-serve.log

# output zola-serve.log, assuming using local check
log:
	tail -n 20 zola-server.log
