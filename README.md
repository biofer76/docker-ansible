# Ansible on Docker for automated deployments and pipelines

You can build and use Ansible as Docker container to integrate Ansible tasks and playbooks execution in pipelines or automated jobs.

## First!

You can download the Ansible [Docker image from Docker Hub](https://hub.docker.com/r/devxops/ansible) or build in your local environment from this source.

## Run

Quick way, pull image from https://dockerhub.com and start to play (for building skip and go to Build section):

```
docker run --rm -t devxops/ansible <ansible command and arguments>

# Ansible version
docker run --rm -t devxops/ansible ansible --version
```

## Run an Ansible Project

A very basic project is included in this repository but, of course, you can use your own without including any pice of this repository. 

In order to run your Ansible projects **you have to run Docker Ansible container and mount project folder as volume.**

Let's do it!

My project is stored in `/ansible` folder, the same folder includes a `keys` folder (content is ignored from GIT) where I must store remote hosts private keys.

Basic project structure:

```
ansible/
├── inventory.ini << Hosts configuration
├── keys
│   └── id_rsa << No included, set yours
├── playbook.yml
└── roles
    └── basic
        └── tasks
            └── main.yml
```

If you want to test the Ansible project included in this repository before running on yours:

* Configure one or more hosts in `inventory.ini` file
* Save hosts private key in `keys/` folder
* Run the Ansible Playbook through Docker container

### Run Playbook

From every Ansible project you can run Ansible playbooks by this Docker command:

```
docker run --rm -t --name ansible -v $PWD/ansible:/ansible devxops/ansible ansible-playbook -i inventory.ini playbook.yml
```

In this example Ansible source code is stored in `[project-root]/ansible` folder, if your Ansible source code is in the root folder, modify Docker run command with:

```
-v $PWD:ansible
```

About Docker `run` command arguments:

`--rm` : Container will be deleted at the end of execution

`-t` : Allocate a pseudo-tty to display stdout

`--name` : Name of temporary container

`-v` : Mount Ansible source code volume in `/ansible` container folder


## How to build

You can use `make` command (recommended) or build manually with Docker commands.

Build with `make` and default Ansible / Python versions:

```
make build
```

Build with `make` and custom Ansible / Python versions:

```
# Ansible 
make build ANSIBLE_VERSION=2.9.10

# Python
make build PYTHON_VERSION=3.7.8-slim-buster

# Ansible + Python
make build ANSIBLE_VERSION=2.9.10 PYTHON_VERSION=3.7.8-slim-buster
```
If you want to skip `make` command, build image with **Docker commands**:

```
# Use default version values
docker build -t docker-ansible .

# Set you Ansible and/or Python version
docker build -t docker-ansible --build-arg ANSIBLE_VERSION=2.9.10 --build-arg PYTHON_VERSION=3.7.8-slim-buster .
```

## Ansible Configuration File

Ansible supports several sources for configuring its behavior, including an ini file named `ansible.cfg`, environment variables, command-line options, playbook keywords, and variables.

For global configuration available in a distributed container, set configuration in the `ansible.cfg` file and build with the Docker image.
All settings will be available at every run without any extra argument.

If you need to customize every Ansible project, add a custom `ansible.cfg` file in project root folder (the same folder mounted into Docker container)

Changes can be made and used in a configuration file which will be searched for in the following order:

* ANSIBLE_CONFIG (environment variable if set)
* `/ansible/ansible.cfg` custom settings for every project, it overrides global configuration file, you must replicate all required settings or remove the file.
* `/etc/ansible/ansible.cfg` : included for global settings during Docker image builds, in the root folder there is an example of all available settings, update to your preferences.


Check **current Ansible configuration file** by this commands:

```
<docker run command> ansible-config view
```

## License
MIT

