FROM openjdk:18-oraclelinux8
EXPOSE 25565

ARG server_download_url

ENV INIT_MEMORY_SIZE 1G
ENV MAX_MEMORY_SIZE 1G

WORKDIR /srv
RUN curl -o server.jar ${server_download_url}
RUN echo eula=true > eula.txt
ENTRYPOINT java -Xmx${MAX_MEMORY_SIZE} -Xms${INIT_MEMORY_SIZE} -jar server.jar nogui
