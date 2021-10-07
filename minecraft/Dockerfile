FROM openjdk:18-oraclelinux8
EXPOSE 25565
ENV INIT_MEMORY_SIZE 1G
ENV MAX_MEMORY_SIZE 1G
WORKDIR /srv
RUN curl -o server.jar https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
RUN echo eula=true > eula.txt
ENTRYPOINT java -Xmx${MAX_MEMORY_SIZE} -Xms${MAX_MEMORY_SIZE} -jar server.jar nogui