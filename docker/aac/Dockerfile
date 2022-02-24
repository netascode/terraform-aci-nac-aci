FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install python3 pip git rsync wget unzip curl -y

COPY ./requirements-dev.txt ./
RUN pip install --upgrade pip setuptools pre-commit \
    && pip install -r requirements-dev.txt

RUN wget --quiet https://releases.hashicorp.com/terraform/1.1.6/terraform_1.1.6_linux_amd64.zip \
    && unzip terraform_1.1.6_linux_amd64.zip \
    && mv terraform /usr/local/bin \
    && rm terraform_1.1.6_linux_amd64.zip

RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

RUN curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-amd64.tar.gz \
    && tar -xzf terraform-docs.tar.gz \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/local/bin/terraform-docs \
    && rm terraform-docs.tar.gz
