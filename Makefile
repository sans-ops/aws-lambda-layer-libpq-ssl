result = pglayer
postgresql_version ?= 11.5
zipfile = aws-lambda-layer-libpq-$(postgresql_version).zip
layer_name = postgres-libpq
container_name = libpq-jgpd-$(postgresql_version)

all: build upload

build:
	docker build --rm \
		--build-arg postgresql_version=$(postgresql_version) \
		--build-arg zipfile=$(zipfile) \
		--tag $(result) .
	docker run --name $(container_name) -d $(result) false
	docker cp $(container_name):/home/builder/$(zipfile) .
	docker rm -f $(container_name)

clean:
	docker rmi -f $(result)

upload:
	aws lambda publish-layer-version \
		--layer-name $(layer_name) \
		--zip-file fileb://$(zipfile) \
		--compatible-runtimes python3.6 python3.7
