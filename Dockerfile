FROM lambci/lambda:build-python3.6

RUN \
  useradd builder
USER builder
WORKDIR /home/builder

RUN git clone https://github.com/postgres/postgres.git postgres
RUN git clone https://github.com/psycopg/psycopg2.git psycopg2

RUN \
  cd postgres && \
  git checkout REL_11_5 && \
  ./configure  \
    --with-openssl \
  && \
  make check

RUN \
  cd postgres/tmp_install/usr/local/pgsql && \
  zip -r aws-libpq-lambda-layer.zip lib/libpq.so* /lib64/libssl.so.10 && \
  mv aws-libpq-lambda-layer.zip ~
