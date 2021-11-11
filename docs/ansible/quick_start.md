# Quick Start

A sample inventory including playbooks using [Drone](https://drone.io/) as a CI/CD platform can be found [here](https://wwwin-github.cisco.com/aac/aac-inventory).

There are two options to use the Ansible collection locally, either using the [ready-to-use container image](#ready-to-use-container) or install python and ansible requirements [locally](#local-installation).

## Ready-to-use Container

A dedicated ansible docker image with all the necessary binaries and libraries is available [here](https://hub.docker.com/r/danischm/aac). The image is based on centos:8 linux distribution, it includes python 3, as well as all the necessary python modules, rpms and configuration. The [Dockerfile](https://wwwin-github.cisco.com/aac/ansible-aac/blob/master/docker/aac/Dockerfile) to create the image can be found in ```docker/aac/Dockerfile```.

## Local Installation

Alternatively the necessary python requirements can be installed locally with ```pip```. It is recommended to install requirements in a new or existing ```virtualenv```, eg. using [pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv).

```
$ python -m virtualenv aac          # Create a virtualenv if one does not already exist
$ source aac/bin/activate           # Activate the virtual environment
$ pip install -r requirements.txt   # Install python requirements
$ pip install ansible-lint          # Optionally install ansible-lint
```

In a second step it is necessary to install the ansible collection (and its dependencies). This can be done by creating a ```requirements.yml``` file with the following content:

```yaml
---
collections:
  - name: https://wwwin-github.cisco.com/aac/ansible-aac.git
    type: git
    version: master
```

Then install the collection with:

```
$ ansible-galaxy install -r requirements.yml
```
