# Wrapper image around the official Buzz relay image
# (ghcr.io/block/buzz, pinned by digest). Adds only:
#   - first-start Nostr keypair bootstrap (data/buzz/keys.env)
#   - su-exec for dropping from root to the image's `buzz` user
# The relay binary itself comes from upstream untouched.
FROM ghcr.io/block/buzz@sha256:ed5af1277d4c92c7bfc4c0b99057e1684dd004264fc6dc0d0988dadaf9e36a3a

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends su-exec; \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/buzz-umbrel-entrypoint
RUN chmod +x /usr/local/bin/buzz-umbrel-entrypoint

# Persistent app data (keys.env, git repos) is mounted here by Umbrel.
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/buzz-umbrel-entrypoint"]
