FROM alpine
MAINTAINER Dávid Halász <skateman@skateman.eu>

ENV CRYSTAL_ENV production
ENV PORT 8090

RUN mkdir -p /opt/silvio
COPY . /opt/silvio
WORKDIR /opt/silvio

RUN apk add crystal               \
            shards                \
            libressl-dev          \
            libevent-dev          \
            musl-dev              \
            postgresql-dev        \
            zlib-dev              \
            libevent              \
            libgc++               \
            gc                    \
            pcre                  \
            postgresql-libs    && \
                                  \
    shards build silvio-server && \
                                  \
    apk del crystal               \
            shards                \
            libressl-dev          \
            libevent-dev          \
            musl-dev              \
            postgresql-dev        \
            zlib-dev           && \
                                  \
    adduser -S silvio          && \
    addgroup -S silvio

USER silvio:silvio
CMD bin/silvio-server -b 0.0.0.0 -p $PORT -d $DATABASE_PATH
