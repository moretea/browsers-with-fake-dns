FROM golang:1.14-buster AS easy-novnc-build
WORKDIR /src
RUN go mod init build && \
    go get github.com/geek1011/easy-novnc@v1.1.0 && \
    go build -o /bin/easy-novnc github.com/geek1011/easy-novnc

FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && \
    apt-get install -y \
    --no-install-recommends \
    supervisor gosu \
    ca-certificates xdg-utils  \
    tigervnc-standalone-server \
    bind9 python3 python3-pip \
    dbus-x11 openbox x11-xserver-utils \
    firefox chromium-browser \
    iputils-ping dnsutils curl \
    xfce4-terminal && \
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/desktop-directories && \
    pip3 install pyyaml

RUN groupadd --gid 1000 app && \
    useradd --home-dir /data --shell /bin/bash --uid 1000 --gid 1000 app && \
    mkdir -p /data
VOLUME /data

COPY --from=easy-novnc-build /bin/easy-novnc /usr/local/bin/
COPY supervisord.conf /etc/
COPY welcome.html /
COPY --chown=755 reconfigure-bind /usr/local/bin/
COPY openbox_menu.xml /var/lib/openbox/debian-menu.xml

EXPOSE 8080

CMD ["sh", "-c", "chown app:app /data /dev/stdout && exec supervisord"]

# TIP: copy your zone in the image, and ship the image to a semi-technical audience.
# COPY zone.yaml /data/zone.yaml
