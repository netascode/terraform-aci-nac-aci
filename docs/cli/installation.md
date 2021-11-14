# Installation

## Using _Cisco AIDE Toolkit_ application

Follow the CAT installation instructions available [here](https://cisco.sharepoint.com/sites/AIDE/SitePages/CX-AIDE-Toolkit.aspx#installation-instructions) and install *ACI as Code* from within the application. Launching it will open an interactive terminal session into a container running the `aac-tool` application.

## Using the ready-to-use container image

Working locally requires a proper installation of Docker.

* OSX: [https://docs.docker.com/docker-for-mac/install/](https://docs.docker.com/docker-for-mac/install/)
* Windows: [https://docs.docker.com/docker-for-windows/install/](https://docs.docker.com/docker-for-windows/install/)
* Linux: Check the internet for the OS specific installation steps.

The container image is published here: [https://containers.cisco.com/repository/aide/aac-tool](https://containers.cisco.com/repository/aide/aac-tool)

Run the container and start an interactive session:

```shell
$ docker run -it containers.cisco.com/aide/aac-tool bash
```

Be aware that by default you do not have access to any files on your host from within the container. In order to share/access files from your host you need to create a shared volume which maps a directory from your host into the container environment. This can done using the `-v` flag when using the `docker run` command.

```shell
$ docker run -it -v $(pwd):/home containers.cisco.com/aide/aac-tool bash
```

## Local installation

Python 3.6+ is required to install `aac-tool`. Don't have Python 3.6 or later? See [Python 3 Installation & Setup Guide](https://realpython.com/installing-python/).

The recommended way of installing `aac-tool` is with [pipx](https://pipxproject.github.io/pipx/). `pipx` is a tool to install and manage CLI applications. It ensures isolation (aka virtual environments), yet still makes the applications available in your shell.

Alternatively, `aac-tool`can be installed in a virtual environment using `pip` directly from source:

```shell
$ pip install .
```

### Install `pipx`

```shell
$ python3 -m pip install --user pipx
$ python3 -m pipx ensurepath
```

### Install `aac-tool`

```shell
$ pipx install --pip-args "--extra-index-url https://engci-maven.cisco.com/artifactory/api/pypi/as-dev-pypi/simple" aac-tool
$ aac-tool --version
aac-tool, version 0.0.1
```

Alternatively, the pypi index url can be added to the pip config file. For Windows the path is ```%HOMEPATH%\pip\``` and the filename is ```pip.ini```. For Linux/Mac the path is ```~/.pip/``` and the filename is ```pip.conf```.

```shell
[global]
extra-index-url = https://engci-maven-master.cisco.com/artifactory/api/pypi/as-dev-pypi/simple
```

### Upgrade

```shell
$ pipx upgrade --pip-args "--extra-index-url https://engci-maven.cisco.com/artifactory/api/pypi/as-dev-pypi/simple" aac-tool
```
