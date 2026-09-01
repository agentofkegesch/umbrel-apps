#!/bin/bash
# Buzz Umbrel entrypoint: bootstrap Nostr keypairs on first start, then exec
# the relay as the image's `buzz` user (uid 1000) via su-exec.
set -eu

KEYS_DIR=/data/buzz
KEYS_FILE="$KEYS_DIR/keys.env"

gen_keypair() {
  # Prints "PRIV=<64hex> PUB=<64hex>" (BIP-340 x-only pubkey) for a fresh
  # secp256k1 key. Uses openssl from the base image - no dependency on
  # `buzz-admin generate-key` output format.
  local pem text priv pub
  pem=$(mktemp)
  openssl ecparam -name secp256k1 -genkey -noout -out "$pem" 2>/dev/null
  text=$(openssl ec -in "$pem" -noout -text 2>/dev/null)
  rm -f "$pem"
  priv=$(printf '%s\n' "$text" | awk '/priv:/{f=1;next} /pub:/{f=0} f' | tr -d ' :\n')
  pub=$(printf '%s\n' "$text" | awk '/pub:/{f=1;next} f' | tr -d ' :\n' | sed 's/^04//' | cut -c1-64)
  # Pad a stripped leading zero back to 32 bytes (value-preserving).
  while [ "${#priv}" -lt 64 ]; do priv="0$priv"; done
  echo "PRIV=$priv PUB=$pub"
}

mkdir -p "$KEYS_DIR" /data/git

if [ ! -s "$KEYS_FILE" ]; then
  echo "[buzz-entrypoint] First start: generating Nostr keypairs..."
  RELAY=$(gen_keypair)
  OWNER=$(gen_keypair)
  {
    echo "# Buzz relay identity + owner keypairs (BIP-340 secp256k1)"
    echo "# Generated on first start. BACK THIS FILE UP - losing it means"
    echo "# losing the relay identity and owner access to the community."
    echo "BUZZ_RELAY_PRIVATE_KEY=$(printf '%s\n' "$RELAY" | sed -n 's/^PRIV=//p')"
    echo "RELAY_OWNER_PRIVATE_KEY=$(printf '%s\n' "$OWNER" | sed -n 's/^PRIV=//p')"
    echo "RELAY_OWNER_PUBKEY=$(printf '%s\n' "$OWNER" | sed -n 's/^PUB=//p')"
  } > "$KEYS_FILE"
  chmod 600 "$KEYS_FILE"
  echo "[buzz-entrypoint] ===================================================="
  echo "[buzz-entrypoint] Keypairs written to $KEYS_FILE"
  echo "[buzz-entrypoint] Import RELAY_OWNER_PRIVATE_KEY into your Buzz"
  echo "[buzz-entrypoint] client to administer this community."
  echo "[buzz-entrypoint] ===================================================="
fi

set -a
# shellcheck disable=SC1090
. "$KEYS_FILE"
set +a
export BUZZ_RELAY_PRIVATE_KEY RELAY_OWNER_PUBKEY

# Relay runs as the non-root `buzz` user from the base image; runuser
# (util-linux, preinstalled in debian-slim) preserves the exported env.
export HOME=/var/lib/buzz
chown -R buzz:buzz "$KEYS_DIR" /data/git || true
exec runuser -u buzz -- /usr/local/bin/buzz-relay
