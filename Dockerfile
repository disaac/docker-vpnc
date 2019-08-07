FROM alpine:latest
LABEL maintainer "Daniel - https://github.com/disaac"

RUN apk add --no-cache --virtual .build-deps \
      gcc \
      freetype-dev \
      musl-dev && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
      vpnc \
      ufw \
      dante-server && \
    apk add --no-cache \
      openssh \
      shadow \
      curl \
      jq \
      bash \
      dumb-init \
      ip6tables && \
    sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config && \
    ssh-keygen -A && \
    passwd -d root && \
    mkdir -p /etc/service/vpnc

ENV VPNC_GATEWAY=**None** \
    VPNC_ID=**None** \
    VPNC_SECRET=**None** \
    VPNC_USERNAME=**None** \
    VPNC_PASSWORD=**None** \
    VPNC_SSHD_AUTHORIZED_KEYS=**None** \
    CREATE_TUN_DEVICE=true
COPY bin/vpnc.sh /etc/service/vpnc/run
# Expose port and run
##TODO: Add danted proxy service configuration
# EXPOSE 8888 # Used for danted proxy service
EXPOSE 22
CMD ["dumb-init", "/etc/service/vpnc/run"]
