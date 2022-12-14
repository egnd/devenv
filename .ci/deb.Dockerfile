ARG DISTRO_NAME=ubuntu:latest
FROM ${DISTRO_NAME}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y sudo bash make ansible

WORKDIR /src

RUN adduser --disabled-password --gecos '' admin && \
    adduser admin sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chown -R 1000:1000 /src

USER admin

ENTRYPOINT ["make"]
