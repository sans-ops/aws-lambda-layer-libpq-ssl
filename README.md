[![Build Status](https://travis-ci.org/sans-servers/aws-lambda-layer-libpq-ssl.svg?branch=master)](https://travis-ci.org/sans-servers/aws-lambda-layer-libpq-ssl)

# PostgreSQL AWS Lambda Layer

AWS Lambda Layer with PostgreSQL client with SSL built-in.


## Description

AWS Lambda runtimes do not include the PostgreSQL client library, [libpq](https://www.postgresql.org/docs/11/libpq.html), and creates a challenge when a Lambda function requires a connection to a PostgreSQL database.  [DrLuke](https://github.com/DrLuke) solves the problem to a good degree with his instructions on how to build a [libpq Lambda Layer](https://github.com/DrLuke/postgres-libpq-aws-lambda-layer) (which I found via [Maciej Winnicki](https://github.com/mthenw)'s [awesome-layers](https://github.com/mthenw/awesome-layers) list).  This repo productionizes DrLuke's work by:

1. Creating a set of AWS Lambda Layers with libpq (currently from PostgreSQL 11.5) in all regions that support Lambda; and
1. Adds SSL support to libpq so that one can connect with an encrypted connection;
1. Provide clear provenance for the layer by completely building and publishing them via Travis CI.

## Usage

The following are the ARNs of the latest layer on AWS that you can add to your Lambda functions.

```
arn:aws:lambda:ap-northeast-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:ap-northeast-2:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:ap-south-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:ap-southeast-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:ap-southeast-2:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:ca-central-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:eu-central-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:eu-north-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:eu-west-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:eu-west-2:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:eu-west-3:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:sa-east-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:us-east-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:us-east-2:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:us-west-1:032012114076:layer:postgresql-libpq-ssl:1
arn:aws:lambda:us-west-2:032012114076:layer:postgresql-libpq-ssl:1
```

## References

1. https://github.com/DrLuke/postgres-libpq-aws-lambda-layer
1. https://github.com/jetbridge/psycopg2-lambda-layer
1. https://github.com/jkehler/awslambda-psycopg2
1. https://github.com/lambci/docker-lambda
