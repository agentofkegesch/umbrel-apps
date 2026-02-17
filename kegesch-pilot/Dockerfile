FROM debian:bookworm-slim

ARG TARGETARCH

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    openssh-client \
    ca-certificates \
    jq \
    procps \
    vim \
    nano \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    TTYD_ARCH="${TARGETARCH}"; \
    if [ "${TARGETARCH}" = "amd64" ]; then TTYD_ARCH="x86_64"; fi; \
    if [ "${TARGETARCH}" = "arm64" ]; then TTYD_ARCH="aarch64"; fi; \
    curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.${TTYD_ARCH}" -o /usr/local/bin/ttyd; \
    chmod +x /usr/local/bin/ttyd

RUN curl -fsSL https://raw.githubusercontent.com/alekspetrov/pilot/main/install.sh | bash

RUN curl -fsSL https://opencode.ai/install | bash

ENV PATH="/root/.local/bin:${PATH}"

RUN mkdir -p /projects /config /root/.ssh && \
    chmod 700 /root/.ssh

ENV PILOT_CONFIG_DIR=/config
ENV EXECUTOR_BACKEND=opencode
ENV PROJECTS_DIR=/projects

WORKDIR /projects

EXPOSE 7681

CMD ["ttyd", "-W", "-t", "fontSize=14", "-p", "7681", "bash"]
