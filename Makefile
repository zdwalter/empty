MOCHA_OPTS=
REPORTER = spec

check: test

test: test-unit 

test-unit:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--compilers coffee:coffee-script \
		--reporter $(REPORTER) \
		$(MOCHA_OPTS)

test-cov: lib-cov
	@LIB_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html

lib-cov: build
	@jscoverage lib-js lib-cov || echo "download and install from https://github.com/visionmedia/node-jscoverage"

build: clean
	@coffee -o lib-js -c lib

clean:
	rm -f coverage.html
	rm -fr lib-cov
	rm -fr lib-js

install:
	bash install.sh

.PHONY: test test-unit clean build install
