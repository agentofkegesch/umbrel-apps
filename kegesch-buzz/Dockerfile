# Wrapper image around the official Buzz relay image
# (ghcr.io/block/buzz, pinned by digest). Adds only the first-start Nostr
# keypair bootstrap (data/buzz/keys.env). The relay binary itself comes from
# upstream untouched; user switch uses runuser from util-linux (preinstalled).
FROM ghcr.io/block/buzz@sha256:ed5af1277d4c92c7bfc4c0b99057e1684dd004264fc6dc0d0988dadaf9e36a3a

USER root

COPY docker-entrypoint.sh /usr/local/bin/buzz-umbrel-entrypoint
RUN chmod +x /usr/local/bin/buzz-umbrel-entrypoint

# Persistent app data (keys.env, git repos) is mounted here by Umbrel.
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/buzz-umbrel-entrypoint"]
