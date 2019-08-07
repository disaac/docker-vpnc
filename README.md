# vpnc

Containerized Cisco VPN Client with SSH access automated to container.

## Environment Variables


Make sure that `.env` file is populated with required values:

```bash
cp -p .env.sample .env
```

Then Edit the file and put correct values where needed. Leave the `VPNC_SSHD_AUTHORIZED_KEYS` as is this will be populated when `bin/hostPrep.sh` is ran.

```bash
VPNC_GATEWAY=<IP_NAME_OF_IPSEC_GATEWAY>
VPNC_ID=<IPSEC_GROUP_NAME>
VPNC_SECRET=<IPSEC_GROUP_SECRET>
VPNC_USERNAME=<XAUTH_USERNAME>
VPNC_PASSWORD=<XAUTH_PASSWORD>
VPNC_SSHD_AUTHORIZED_KEYS=GENERATED_AUTOMATICALLY
CREATE_TUN_DEVICE=true
```

## Using image

```bash
# Creates ssh keys and updates the .env file with generated public ssh key
bin/hostPrep.sh
# Runs container and puts in background
docker-compose up -d
# SSH's into container once its up
bin/sshvpnc
# Kills container and removes it so it can be relaunched again easily
docker-compose kill && docker-compose rm -f
```

## Building new image

```bash
docker-compose build
```

## Credits/References

- Credit to [jsecchiero](https://github.com/jsecchiero/vpnc) for initial docker configuration.
