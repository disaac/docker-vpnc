#!/usr/bin/env bash
function createContainerKeys () {
  local keyname
  local pubkey
  local overwrite
  local sshport
  local sshuser
  local sshalias
  local envfile
  overwrite="${1:-true}"
  keyname="${2:-vpncsshkey}"
  sshport="${3:-2299}"
  sshuser="${4:-root}"
  sshalias="sshvpnc"
  envfile=".env"
  if [ -x "$(command -v ssh-keygen)" ]; then
    if [[ ${overwrite,,} = "true" ]]; then
      echo "Creating VPNC ssh key ${keyname} to access container..."
      rm -rf "${keyname}"
      rm -rf "${keyname}.pub"
      ssh-keygen -t rsa -b 2048 -f "${keyname}" -C "${keyname}" -N "" -q
    fi
    if [ -s "${keyname}" ] && [ -s "${keyname}".pub ];then
      chmod 0600 "${keyname}"
      echo "Updating the VPNC_SSHD_AUTHORIZED_KEYS value in the .env"
      pubkey=$(< "${keyname}".pub)
      sed "s#VPNC_SSHD_AUTHORIZED_KEYS=.*#VPNC_SSHD_AUTHORIZED_KEYS=${pubkey}#"\
        "${envfile}" > "${envfile}".new && \
        mv -- "${envfile}".new "${envfile}"
      grep VPNC_SSHD_AUTHORIZED_KEYS "${envfile}"
      echo "Creating ssh alias script to use key and login to container..."
      cat > bin/${sshalias} <<EOF
      #!/usr/bin/env bash
      set -xv
      ssh -o "StrictHostKeyChecking=no" -i "${keyname}" -p ${sshport} ${sshuser}@127.0.0.1
EOF
      [[ -s bin/"${sshalias}" ]] && chmod a+x bin/"${sshalias}"
      echo "Run the following to access the container after start:"
      echo "bin/${sshalias}"
    fi
  fi
}

createContainerKeys "true" "vpncsshkey" "2299" "root"
echo ""
echo "Container keys should be created now you can run the following command to start the container."
echo "docker-compose up -d"
echo "Once container is running you can execute the bin/sshvpnc commadn to access it"
echo ""
echo "To stop container once done run"
echo "docker-compose kill && docker-compose rm -f"
