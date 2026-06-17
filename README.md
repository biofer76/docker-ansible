# docker-ansible

Lightweight Ansible Docker image based on Alpine Linux. Designed to run Ansible playbooks without a local Ansible installation.

[![Build and Push Docker Image](https://github.com/biofer76/docker-ansible/actions/workflows/build.yml/badge.svg)](https://github.com/biofer76/docker-ansible/actions/workflows/build.yml)

## Usage

### Wrapper script (recommended)

The `ansible` wrapper script runs any Ansible command transparently, mounting your current directory and SSH keys automatically.

```bash
./ansible playbook playbook.yml -i inventory/hosts
./ansible galaxy collection install community.general
./ansible vault encrypt vars/secrets.yml
./ansible lint playbook.yml
./ansible -m ping all
```

### Direct Docker run

The image entrypoint supports the same subcommands as the wrapper script:

```bash
docker run --rm \
  -v $(pwd):/ansible \
  -v ~/.ssh:/root/.ssh:ro \
  -v ~/.ansible:/root/.ansible \
  --network host \
  particles/ansible:latest playbook playbook.yml -i inventory/hosts
```

## SSH & connectivity

The wrapper script automatically mounts:

- `~/.ssh` → `/root/.ssh` (read-only) - SSH private keys for connecting to remote hosts
- `~/.ansible` → `/root/.ansible` - Ansible cache and retry files
- `--network host` - allows Ansible to reach hosts on the local network

Host key checking is disabled by default via `ansible.cfg`.

## Configuration

The image ships with a default `/etc/ansible/ansible.cfg`:

```ini
[defaults]
retry_files_enabled     = False
host_key_checking       = False
interpreter_python      = auto_silent
stdout_callback         = default
roles_path              = roles
collections_path        = collections

[ssh_connection]
pipelining              = True
ssh_args                = -o ControlMaster=auto -o ControlPersist=60s
```

### Project-level override

Place an `ansible.cfg` in your project root — it will be picked up automatically since `/ansible` is the container working directory and takes precedence over `/etc/ansible/ansible.cfg`:

```ini
# my-project/ansible.cfg
[defaults]
inventory = inventory/hosts
vault_password_file = .vault_pass
```

### Runtime override via environment variables

Any `ANSIBLE_*` env var overrides both config files:

```bash
ANSIBLE_STDOUT_CALLBACK=debug ./ansible playbook playbook.yml
```

Or in `docker-compose.yml`:

```yaml
environment:
  - ANSIBLE_STDOUT_CALLBACK=debug
  - ANSIBLE_VAULT_PASSWORD_FILE=/ansible/.vault_pass
```

## Environment variables

| Variable        | Default                    | Description                             |
| --------------- | -------------------------- | --------------------------------------- |
| `ANSIBLE_IMAGE` | `particles/ansible:latest` | Docker image used by the wrapper script |

## Image tags

| Tag      | Description                                  |
| -------- | -------------------------------------------- |
| `latest` | Latest build from the `main` branch          |
| `weekly` | Rebuilt weekly to pick up dependency updates |
| `vX.Y.Z` | Pinned release (e.g. `v2.20.0`)              |

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

Use the `ansible` wrapper script - collections are written to `~/.ansible` on the host and persist after the container exits.

```bash
./ansible galaxy collection install community.general
./ansible galaxy install -r requirements.yml
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
  particles/ansible:local playbook playbook-test.yml
```

## Available on

- **Docker Hub**: [particles/ansible](https://hub.docker.com/r/particles/ansible)

## License

[MIT](https://raw.githubusercontent.com/biofer76/docker-ansible/refs/heads/main/LICENSE)
