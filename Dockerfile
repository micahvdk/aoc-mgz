FROM python:3.12-slim AS base

LABEL org.opencontainers.image.source="https://github.com/micahvdk/aoc-mgz"
LABEL org.opencontainers.image.description="Age of Empires 2 recorded game parser (mgz) — micahvdk fork with v67.0 'Last Chieftains' save support"
LABEL org.opencontainers.image.licenses="MIT"

WORKDIR /opt/mgz

# Install build deps only for the install step; strip them after.
RUN apt-get update \
 && apt-get install -y --no-install-recommends git \
 && rm -rf /var/lib/apt/lists/*

# Copy sources and install the package (entry point: `mgz` console script).
COPY setup.py README.md ./
COPY mgz ./mgz
COPY tests ./tests

RUN pip install --no-cache-dir .

# Default working dir for mounted recordings.
WORKDIR /data

# Provide a friendly default: `docker run ghcr.io/micahvdk/aoc-mgz --help`
ENTRYPOINT ["mgz"]
CMD ["--help"]
