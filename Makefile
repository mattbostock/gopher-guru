.PHONY: all build test clean

all: build test

build:
	mkdir build
	go build -o build/runner ./runner
	cp runner/runner_lambda_shim.js build
	zip --move --junk-paths build/runner.zip build/*

test:
	true

clean:
	rm -rf build
