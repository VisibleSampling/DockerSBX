FROM docker/sandbox-templates:claude-code
USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ansible \
    ansible-lint \
    python3-pip \
    build-essential \
    curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | \
    env UV_INSTALL_DIR=/usr/local/bin sh

USER agent
