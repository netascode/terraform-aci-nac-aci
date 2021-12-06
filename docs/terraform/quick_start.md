# Quick Start

A sample repository using [Drone](https://drone.io/) as a CI/CD platform can be found [here](https://wwwin-github.cisco.com/netascode/terraform-aac).

There are two options to run Terraform locally, either using the [ready-to-use container image](#ready-to-use-container) or install Terraform and python requirements [locally](#local-installation).

## Ready-to-use Container

A dedicated docker image with all the necessary binaries and libraries is available [here](https://hub.docker.com/r/danischm/aac). The image is based on CentOS 8 Linux distribution, it includes Terraform, Python 3, as well as all the necessary dependencies. The Dockerfile to create the image can be found [here](https://wwwin-github.cisco.com/aac/ansible-aac/blob/master/docker/aac/Dockerfile).

## Local Installation

Alternatively Terraform and the necessary python requirements can be installed locally. Binaries and installation instructions of Terraform can be found [here](https://www.terraform.io/downloads.html). It is recommended to install Python requirements in a new or existing ```virtualenv```, eg. using [pyenv](https://github.com/pyenv/pyenv) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv).

```shell
$ python -m virtualenv aac          # Create a virtualenv if one does not already exist
$ source aac/bin/activate           # Activate the virtual environment
$ pip install robotframework robotframework-pabot RESTinstance yamale-aac yamllint
```

## Terraform Configuration

Depending on where the Terraform state should be maintained the backend and provider configuration (in [main.tf](https://wwwin-github.cisco.com/netascode/terraform-aac/blob/master/main.tf)) should be updated.

```hcl 
terraform {
  required_providers {
    aci = {
      source  = "netascode/aci"
      version = ">= 0.2.0"
    }
    utils = {
      source  = "cloudposse/utils"
      version = ">= 0.15.0"
    }
  }
}

provider "aci" {
  username    = "terraform"
  password    = "terraform"
  url         = "https://10.1.1.100"
}
```
