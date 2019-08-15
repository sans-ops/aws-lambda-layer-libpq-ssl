postgresql_version ?= 11.5
zipfile = aws-lambda-layer-libpq-$(postgresql_version).zip
layer_name = postgresql-libpq-dev
container_name = libpq-jgpd-$(postgresql_version)
result = libpq-layer-$(postgresql_version)
layer_statement_id = public-read

all: build upload share

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

share: upload
	$(eval version = $(shell aws lambda list-layers \
		--query "Layers[?LayerName=='$(layer_name)'].LatestMatchingVersion.Version" \
		--output text \
	))
	-aws lambda remove-layer-version-permission \
		--layer-name $(layer_name) \
		--statement-id $(layer_statement_id) \
		--version-number $(version)
	aws lambda add-layer-version-permission \
		--layer-name $(layer_name) \
		--statement-id $(layer_statement_id) \
		--action lambda:GetLayerVersion \
		--principal '*' \
		--version-number $(version)
	aws lambda list-layers --query "Layers[?LayerName=='$(layer_name)']"
