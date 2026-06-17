ARG PYTHON_VERSION=3.14
FROM python:${PYTHON_VERSION}-alpine

ARG ANSIBLE_VERSION="2.20"
LABEL maintainer="Fabio Ferrari <github@particles.io>"
LABEL description="Ansible in Docker - lightweight Alpine-based image"
LABEL org.opencontainers.image.source="https://github.com/biofer76/docker-ansible"

COPY ansible.cfg /etc/ansible/ansible.cfg
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN apk add --no-cache \
        openssh-client \
        sshpass \
        git \
        rsync \
        bash \
    && pip install --no-cache-dir \
        ansible-core${ANSIBLE_VERSION:+==${ANSIBLE_VERSION}} \
        ansible-lint \
        jmespath \
    && ansible --version \
    && chmod +x /usr/local/bin/entrypoint.sh \
    && rm -rf /root/.cache

WORKDIR /ansible

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]