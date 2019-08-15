postgresql_version ?= 11.5
zipfile = aws-lambda-layer-libpq-$(postgresql_version).zip
layer_name = postgresql-libpq-dev
container_name = libpq-jgpd-$(postgresql_version)
result = libpq-layer-$(postgresql_version)
layer_statement_id = public-read
region ?= us-east-1
aws = aws --region $(region)
regions = \
	ap-northeast-1 \
	ap-northeast-2 \
	ap-south-1 \
	ap-southeast-1 \
	ap-southeast-2 \
	ca-central-1 \
	eu-central-1 \
	eu-north-1 \
	eu-west-1 \
	eu-west-2 \
	eu-west-3 \
	sa-east-1 \
	us-east-1 \
	us-east-2 \
	us-west-1 \
	us-west-2

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
	$(aws) lambda publish-layer-version \
		--layer-name $(layer_name) \
		--zip-file fileb://$(zipfile) \
		--compatible-runtimes python3.6 python3.7

deploy: upload
	$(eval version = $(shell $(aws) lambda list-layers \
		--query "Layers[?LayerName=='$(layer_name)'].LatestMatchingVersion.Version" \
		--output text \
	))
	-$(aws) lambda remove-layer-version-permission \
		--layer-name $(layer_name) \
		--statement-id $(layer_statement_id) \
		--version-number $(version)
	$(aws) lambda add-layer-version-permission \
		--layer-name $(layer_name) \
		--statement-id $(layer_statement_id) \
		--action lambda:GetLayerVersion \
		--principal '*' \
		--version-number $(version)
	$(aws) lambda list-layers --query "Layers[?LayerName=='$(layer_name)']"

list:
	$(aws) lambda list-layers \
		--query "Layers[?LayerName=='$(layer_name)'].LatestMatchingVersion.LayerVersionArn" \
		--output text

deploy-all:
	for r in $(regions); do \
		$(MAKE) deploy postgresql_version=$(postgresql_version) region=$$r; \
	done

list-all:
	for r in $(regions); do \
		aws --region=$$r lambda list-layers \
			--query "Layers[?LayerName=='$(layer_name)'].LatestMatchingVersion.LayerVersionArn" \
			--output text; \
	done
