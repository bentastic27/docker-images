FROM ubuntu

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt install curl dnsutils python3 python3-pip --yes && \
    pip3 install awscli --upgrade --no-cache-dir && \
    apt remove curl python3-pip --yes && apt autoremove --yes && apt clean --yes

COPY entrypoint.sh /
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
