FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    tar \
    nginx \
    openssh-server \
    procps \
    iproute2 \
    net-tools \
    nano \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
    /run/sshd \
    /root/.ssh \
    /data/x-ui \
    /usr/local/x-ui

WORKDIR /tmp

RUN wget -O x-ui.tar.gz \
    https://github.com/MHSanaei/3x-ui/releases/download/v3.7.0/x-ui-linux-amd64.tar.gz \
    && tar -xzf x-ui.tar.gz \
    && cp -a x-ui/. /usr/local/x-ui/ \
    && rm -rf x-ui x-ui.tar.gz

COPY railway.conf /etc/nginx/sites-available/default

COPY start-railway.sh /usr/local/bin/start-railway.sh

RUN sed -i 's/\r$//' /usr/local/bin/start-railway.sh \
    && chmod +x /usr/local/bin/start-railway.sh

EXPOSE 8080
EXPOSE 22

ENTRYPOINT ["/usr/local/bin/start-railway.sh"]
