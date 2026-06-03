FROM python:3.12-slim AS base

ARG TARGETARCH

# Install system dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -g 1000 openbb && \
    useradd -u 1000 -g openbb -m -s /bin/bash openbb

# Install OpenBB Platform with common free providers
RUN set -eux; \
    pip install --no-cache-dir \
    openbb \
    openbb-platform-api \
    && rm -rf /root/.cache/pip

# Create data directory
RUN mkdir -p /home/openbb/.openbb_platform && \
    chown -R openbb:openbb /home/openbb

USER openbb
WORKDIR /home/openbb

# Pre-build the platform on first install to speed up startup
RUN openbb-build 2>/dev/null || true

EXPOSE 6900

# Run the API server
CMD ["openbb-api", "--host", "0.0.0.0", "--port", "6900"]
