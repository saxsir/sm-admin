install:
	bundle install --path vendor/bundle
	npm install
server:
	./bin/rails server -b 0.0.0.0
capture-bg-run:
	nohup bin/rails runner HelperScript::capture_images > out.log 2> err.log < /dev/null &
