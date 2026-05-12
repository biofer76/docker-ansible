ARG PYTHON_VERSION=3.14
FROM python:${PYTHON_VERSION}-alpine

ARG ANSIBLE_VERSION="2.20"
LABEL maintainer="Fabio Ferrari <11944267+biofer76@users.noreply.github.com>"
LABEL description="Ansible in Docker - lightweight Alpine-based image"
LABEL org.opencontainers.image.source="https://github.com/biofer76/docker-ansible"

RUN apk add --no-cache \
        openssh-client \
        sshpass \
        git \
        rsync \
        bash \
    && pip install --no-cache-dir \
        ansible${ANSIBLE_VERSION:+==${ANSIBLE_VERSION}} \
        ansible-lint \
        jmespath \
    && ansible --version \
    && rm -rf /root/.cache

WORKDIR /ansible

ENTRYPOINT ["ansible-playbook"]
CMD ["--version"]