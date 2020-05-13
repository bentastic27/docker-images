FROM ubuntu
RUN apt-get update && apt install curl unzip dnsutils --yes && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && ./aws/install && rm awscliv2.zip && \
    apt remove curl unzip --yes && apt autoremove --yes && apt clean --yes
COPY entrypoint.sh /
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
