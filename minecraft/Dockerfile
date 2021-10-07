FROM openjdk:18-oraclelinux8
EXPOSE 25565

ARG server_download_url

ENV INIT_MEMORY_SIZE 1G
ENV MAX_MEMORY_SIZE 1G

ENV MCRCON_HOST 127.0.0.1
ENV MCRCON_PORT 25575
ENV MCRCON_PASS password

WORKDIR /tmp
RUN curl -L -o mcrcon.tar.gz https://github.com/Tiiffi/mcrcon/releases/download/v0.7.1/mcrcon-0.7.1-linux-x86-64.tar.gz && \
    tar zxf mcrcon.tar.gz mcrcon-0.7.1-linux-x86-64/mcrcon && \
    mv mcrcon-0.7.1-linux-x86-64/mcrcon /bin/mcrcon && \
    rm mcrcon.tar.gz

WORKDIR /srv
RUN curl -o server.jar ${server_download_url}
RUN echo eula=true > eula.txt

RUN java -Xmx${MAX_MEMORY_SIZE} -Xms${INIT_MEMORY_SIZE} -jar server.jar --nogui --initSettings && \
    sed -i 's/enable-rcon=false/enable-rcon=true/' server.properties && \
    sed -i "s/rcon.password=/rcon.password=${MCRCON_PASS}/" server.properties

ENTRYPOINT java -Xmx${MAX_MEMORY_SIZE} -Xms${INIT_MEMORY_SIZE} -jar server.jar nogui
