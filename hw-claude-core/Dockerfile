FROM docker/sandbox-templates:claude-code-docker
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    ansible \
    ansible-lint \
    python3-pip \
    build-essential \
    vim \
    curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN curl -LsSf https://astral.sh/uv/install.sh | \
    env UV_INSTALL_DIR=/usr/local/bin sh
RUN mkdir -p /etc/claude-code
COPY managed-settings.json /etc/claude-code/managed-settings.json
USER agent
