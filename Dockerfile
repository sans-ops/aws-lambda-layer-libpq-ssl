FROM lambci/lambda-base:build

ARG postgresql_version
ARG zipfile

RUN \
  yum upgrade -y
RUN \
  useradd builder
USER builder
WORKDIR /home/builder
ENV PREFIX /home/builder/local

RUN \
  curl -fsSL https://ftp.postgresql.org/pub/source/v${postgresql_version}/postgresql-${postgresql_version}.tar.bz2 \
    -o postgresql-${postgresql_version}.tar.bz2

RUN \
  mkdir ${PREFIX} && \
  tar jxf postgresql-${postgresql_version}.tar.bz2 && \
  cd postgresql-${postgresql_version} && \
  ./configure  \
    --prefix=${PREFIX} \
    --with-openssl \
  && \
  make install

RUN \
  cd ${PREFIX} && \
  zip --must-match -r ${zipfile} lib/libpq.so* /lib64/libssl.so.10 && \
  mv ${zipfile} ~
