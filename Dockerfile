FROM alpine
MAINTAINER Dávid Halász <skateman@skateman.eu>
ENV DATABASE_PATH /mnt/silvio/db.sqlite3
EXPOSE 8090/tcp

RUN mkdir -p /usr/src/silvio
COPY . /usr/src/silvio

RUN apk add crystal                                  \
            shards                                   \
            ruby-dev                                 \
            ruby-bigdecimal                          \
            ruby-json                                \
            ruby-bundler                             \
            make                                     \
            libressl-dev                             \
            libevent-dev                             \
            musl-dev                                 \
            sqlite-dev                               \
            zlib-dev                                 \
            gc                                       \
            pcre                                     \
            libgc++                                  \
            libevent                                 \
            sqlite-libs                           && \
                                                     \
    cd /usr/src/silvio                            && \
    bundle install                                && \
    mkdir -p $(dirname $DATABASE_PATH)            && \
                                                     \
    shards build silvio-server                    && \
    mv bin/silvio-server /bin                     && \
                                                     \
    gem uninstall -aIx                            && \
    apk del crystal                                  \
            shards                                   \
            ruby-dev                                 \
            ruby-bigdecimal                          \
            ruby-json                                \
            ruby-bundler                             \
            make                                     \
            libressl-dev                             \
            libevent-dev                             \
            musl-dev                              && \
    rm -rf /usr/src/silvio                        && \
                                                     \
    adduser -S silvio                             && \
    addgroup -S silvio                            && \
    chown -R silvio:silvio $(dirname $DATABASE_PATH)

USER silvio:silvio
CMD /bin/silvio-server
