FROM ubuntu:22.04

ARG RUNNER_VERSION="2.330.0"

# Prevents installdependencies.sh from prompting the user and blocking the image creation
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y curl wget sudo git jq ca-certificates \
        gnupg lsb-release apt-transport-https software-properties-common && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt update && \
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

RUN useradd -G sudo,docker -ms /bin/bash github && \
    install -o github -g github -m 0755 -d /home/github/actions && \
    echo 'github ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/github

USER github
WORKDIR /home/github/actions

RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz


COPY start.sh start.sh

USER root

RUN ./bin/installdependencies.sh && \
    chmod +x ./start.sh

USER github

ENTRYPOINT ["./start.sh"]
