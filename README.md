# docker-ansible

Lightweight Ansible Docker image based on Alpine Linux. Designed to run Ansible playbooks without a local Ansible installation.

[![Build and Push Docker Image](https://github.com/biofer76/docker-ansible/actions/workflows/build.yml/badge.svg)](https://github.com/biofer76/docker-ansible/actions/workflows/build.yml)

## Usage

### Wrapper script (recommended)

The `ansible-playbook` wrapper script runs the Docker image transparently, mounting your current directory and SSH keys automatically.

```bash
./ansible-playbook playbook.yml -i inventory/hosts
```

### Docker Compose

```bash
docker compose run --rm ansible playbook.yml -i inventory/hosts
```

### Direct Docker run

```bash
docker run --rm \
  -v $(pwd):/ansible \
  -v ~/.ssh:/root/.ssh:ro \
  -v ~/.ansible:/root/.ansible \
  --network host \
  particles/ansible:latest playbook.yml -i inventory/hosts
```

## SSH & connectivity

The wrapper script and Compose file automatically mount:

- `~/.ssh` → `/root/.ssh` (read-only) - SSH private keys for connecting to remote hosts
- `~/.ansible` → `/root/.ansible` - Ansible cache and retry files
- `--network host` - allows Ansible to reach hosts on the local network

Host key checking is disabled by default (`ANSIBLE_HOST_KEY_CHECKING=False`).

## Environment variables

| Variable | Default | Description |
|---|---|---|
| `ANSIBLE_IMAGE` | `particles/ansible:latest` | Docker image used by the wrapper script |
| `ANSIBLE_HOST_KEY_CHECKING` | `False` | Enable/disable SSH host key checking |

## Image tags

| Tag | Description |
|---|---|
| `latest` | Latest build from the `main` branch |
| `weekly` | Rebuilt weekly to pick up dependency updates |
| `vX.Y.Z` | Pinned release (e.g. `v2.20.0`) |

```bash
docker pull particles/ansible:latest
docker pull particles/ansible:v2.20.0
```

## Included packages

- `openssh-client`, `sshpass` - SSH connectivity
- `git`, `rsync` - file transfer and role dependencies
- `ansible-core` - core Ansible engine
- `ansible-lint` - playbook linting
- `jmespath` - JSON filtering with `json_query`

## Adding custom collections

Use the `ansible-galaxy` wrapper script - collections are written to `~/.ansible` on the host and persist after the container exits.

```bash
./ansible-galaxy collection install community.general
```

## Development

### Local build

```bash
docker build -t particles/ansible:local .
```

Override default versions:

```bash
docker build \
  --build-arg ANSIBLE_VERSION=2.18 \
  --build-arg PYTHON_VERSION=3.13 \
  -t particles/ansible:local .
```

### Test with the example playbook

```bash
docker run --rm \
  -v $(pwd)/examples:/ansible \
  particles/ansible:local playbook-test.yml
```

## Available on

- **Docker Hub**: [particles/ansible](https://hub.docker.com/r/particles/ansible)

## License

[MIT](LICENSE)
