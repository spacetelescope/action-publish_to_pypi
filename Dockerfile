# Container image that runs your code
FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y \
    build-essential \
    python3-pip \
    python3.6 \
    git \
    && pip3 install pip --upgrade \
    && pip3 install setuptools --upgrade
  

# Copies code file action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

COPY validate_version.py /validate_version.py

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
