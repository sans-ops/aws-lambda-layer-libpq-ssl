result = pglayer

build:
	docker build --rm -t $(result) .
	$(eval container = $(shell docker run -d $(result) false))
	docker cp $(container):/home/builder/aws-libpq-lambda-layer.zip .
	docker rm -f $(container)

clean:
	docker rmi -f $(pglayer)

upload:
	aws lambda publish-layer-version \
		--layer-name postgres-libpq \
		--zip-file fileb://aws-libpq-lambda-layer.zip \
		--compatible-runtimes python3.6
