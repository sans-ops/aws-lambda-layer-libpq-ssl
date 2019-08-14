FROM lambci/lambda:build-python3.7

ARG postgresql_version
ARG zipfile

RUN \
  useradd builder
USER builder
WORKDIR /home/builder

RUN \
  curl -fsSL https://ftp.postgresql.org/pub/source/v${postgresql_version}/postgresql-${postgresql_version}.tar.bz2 \
    -o postgresql-${postgresql_version}.tar.bz2

RUN \
  mkdir ~/local && \
  tar jxf postgresql-${postgresql_version}.tar.bz2 && \
  cd postgresql-${postgresql_version} && \
  ./configure  \
    --prefix=$(pwd)/local \
    --with-openssl \
  && \
  make install

RUN \
  cd ~/local && \
  zip -r ${zipfile} lib/libpq.so* /lib64/libssl.so.10 && \
  mv ${zipfile} ~
