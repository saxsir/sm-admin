setup:
	bundle install --path vendor/bundle
	npm install -g bower
	bin/rake db:migrate
	bin/rake db:seed
install:
	npm install
	bin/rake bower:install
server:
	./bin/rails server -b 0.0.0.0
reset-db:
	rm db/development.sqlite3
	bin/rake db:migrate
	bin/rake db:seed
capture-debug-run:
	bin/rails runner HelperScript::capture_images
capture-bg-run:
	nohup bin/rails runner HelperScript::capture_images > out.log 2> err.log < /dev/null &
