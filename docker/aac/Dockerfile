FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN dpkg-reconfigure dash

RUN apt-get -y update \
    && apt-get -y install software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get -y update \
    && apt-get -y install python3.9 python3.9-venv pip git rsync wget unzip curl jq

RUN unlink /usr/bin/python3 && ln -s /usr/bin/python3.9 /usr/bin/python3

COPY ./requirements-dev.txt ./
RUN pip install --upgrade pip setuptools pre-commit \
    && pip install -r requirements-dev.txt

RUN wget --quiet https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip \
    && unzip terraform_1.4.6_linux_amd64.zip \
    && mv terraform /usr/local/bin \
    && rm terraform_1.4.6_linux_amd64.zip

RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

RUN curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-amd64.tar.gz \
    && tar -xzf terraform-docs.tar.gz \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/local/bin/terraform-docs \
    && rm terraform-docs.tar.gz
