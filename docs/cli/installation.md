# Installation

Python 3.6+ is required to install `aac-tool`. Don't have Python 3.6 or later? See [Python 3 Installation & Setup Guide](https://realpython.com/installing-python/).

The recommended way of installing `aac-tool` is with [pipx](https://pipxproject.github.io/pipx/). `pipx` is a tool to install and manage CLI applications. It ensures isolation (aka virtual environments), yet still makes the applications available in your shell.

Alternatively, `aac-tool`can be installed in a virtual environment using `pip` or run directly from source with the following command:

```shell
$ python3 -m aac_tool
```

## Install `pipx`

```shell
$ python3 -m pip install --user pipx
$ python3 -m pipx ensurepath
```

## Install `aac-tool`

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

# Upgrade

```shell
$ pipx upgrade --pip-args "--extra-index-url https://engci-maven.cisco.com/artifactory/api/pypi/as-dev-pypi/simple" aac-tool
```
