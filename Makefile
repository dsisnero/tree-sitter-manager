.PHONY: install update format lint test build clean

install:
	shards install

update:
	shards update

format:
	crystal tool format src spec bin

lint:
	ameba src spec bin

test:
	crystal spec

build:
	shards build

clean:
	rm -rf ./temp/*
