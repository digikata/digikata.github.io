
default :
	just -l

# publish merge master to pub branch, regen docs, commit and push
publish: gen
	# the pub dir is a submodule branch of this repo w/ just the output docs
	cd pub && git add docs/
	-cd pub && git commit -m "publish from master"
	-cd pub && git push -f origin HEAD:pub
	# resync pub branch to this repo
	git fetch
	git add -u
	git commit -m "publish to pub"
	git push

# generate pages
gen :
	# github pages will only serve a subfolder with the option of docs
	# odd but whatever
	zola build -o pub/docs/

# serve local check
serve :
	# Zola serve will create a temporary ./public directory
	zola serve

serve-op:
	just serve &
	open http://127.0.0.1:1111

open:
	open http://127.0.0.1:1111
