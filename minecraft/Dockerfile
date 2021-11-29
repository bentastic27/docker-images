FROM gcc:bullseye AS build-mcrcon
RUN git clone https://github.com/Tiiffi/mcrcon.git && \
    cd mcrcon && make && make install

FROM alpine:3.15.0
EXPOSE 25565

ENV INIT_MEMORY_SIZE 1G
ENV MAX_MEMORY_SIZE 1G

ENV MCRCON_HOST 127.0.0.1
ENV MCRCON_PORT 25575
ENV MCRCON_PASS password

RUN apk add openjdk17-jre-headless curl jq

COPY --from=build-mcrcon /usr/local/bin/mcrcon /bin/mcrcon

COPY server.properties /srv/
COPY entrypoint.sh /

WORKDIR /srv
ENTRYPOINT /bin/sh /entrypoint.sh
