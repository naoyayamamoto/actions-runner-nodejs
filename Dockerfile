FROM summerwind/actions-runner:ubuntu-20.04 AS runner

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install:
# nodejs18, yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    sudo apt-get update -y && \
    sudo apt-get install -y \
    nodejs \
    build-essential \
    libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
    libodbc1 \
    git-lfs \
    qemu \
    --no-install-recommends && \
    sudo npm install --global yarn && \
    sudo rm -rf /var/lib/apt/lists/*

# DOWNLOAD dependencies
FROM runner AS nodedep
WORKDIR /home/runner
COPY packages/package.json ./
COPY packages/yarn.lock ./
RUN yarn install --frozen-lockfile --ignore-scripts --silent --non-interactive --no-bin-links

# COPY cache
FROM runner
COPY --from=nodedep --chown=runner:runner /home/runner/.cache /home/runner/.cache
