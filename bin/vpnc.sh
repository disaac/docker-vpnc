#!/bin/bash

cat > /etc/vpnc/default.conf <<EOF
IPSec gateway ${VPNC_GATEWAY}
IPSec ID ${VPNC_ID}
IPSec secret ${VPNC_SECRET}
Xauth username ${VPNC_USERNAME}
Xauth password ${VPNC_PASSWORD}
DPD idle timeout (our side) 10
EOF
mkdir -p /root/.ssh
cat > /root/.ssh/authorized_keys <<EOF
${VPNC_SSHD_AUTHORIZED_KEYS}
EOF
chmod 0600 /root/.ssh/authorized_keys
# If create_tun_device is set, create /dev/net/tun
if [[ "${CREATE_TUN_DEVICE,,}" == "true" ]]; then
  mkdir -p /dev/net
  mknod /dev/net/tun c 10 200
  chmod 0666 /dev/net/tun
fi
bash -c "/usr/sbin/sshd -D -e &" && exec /usr/sbin/vpnc default --no-detach --non-inter --local-port 0 --ifmode tun
