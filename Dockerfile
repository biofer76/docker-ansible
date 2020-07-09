ARG PYTHON_VERSION=3.7.8-slim-buster
FROM python:${PYTHON_VERSION}
ARG ANSIBLE_VERSION=2.9.10
LABEL maintainer="fabio@particles.io"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
    openssl \
    openssh-server \
    curl \
    apt-transport-https \
    gnupg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Ansible as Python package
RUN pip install ansible==${ANSIBLE_VERSION}

# Create Ansible project folders
RUN mkdir /ansible && mkdir /etc/ansible
# Copy Global configuration file
COPY ansible.cfg /etc/ansible/ansible.cfg

WORKDIR /ansible