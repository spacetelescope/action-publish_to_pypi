#!/bin/bash -l

set -e

# Publish to the PyPI testing instance URL if the env var 
# PYPI_TEST is set to a non-empty value, otherwise publish
# to the main index.
URL_ARG=""
if [[ "${PYPI_TEST}" != "" ]]; then
    echo -e "\n----------------------------------------------------------------"
    echo "PYPI_TEST var set. Will attempt to publish to the PyPI"
    echo "testing instance."
    echo -e "----------------------------------------------------------------"
    URL_ARG="--repository-url https://test.pypi.org/legacy/"
fi

if [[ "${PYPI_USERNAME_OVERRIDE}" != "" ]]; then
    echo -e "\n----------------------------------------------------------------"
    echo "PYPI_USERNAME_OVERRIDE var set for this repository."
    echo -e "----------------------------------------------------------------"
    TWINE_USERNAME=$PYPI_USERNAME_OVERRIDE
else
    TWINE_USERNAME=$PYPI_USERNAME_STSCI_MAINTAINER
fi
export TWINE_USERNAME

if [[ "${PYPI_PASSWORD_OVERRIDE}" != "" ]]; then
    echo -e "\n----------------------------------------------------------------"
    echo "PYPI_PASSWORD_OVERRIDE var set for this repository."
    echo -e "----------------------------------------------------------------"
    TWINE_PASSWORD=$PYPI_PASSWORD_OVERRIDE
else
    TWINE_PASSWORD=$PYPI_PASSWORD_STSCI_MAINTAINER
fi
export TWINE_PASSWORD

REF=$GITHUB_REF
echo "GITHUB_REF=${REF}"

PYTHON=$(which python3.6)
echo "PYTHON=${PYTHON}"
PIP=$(which pip3)
echo "PIP=${PIP}"
GCC=$(which gcc)
echo "GCC=${GCC}"
GIT=$(which git)
echo "GIT=${GIT}"

/usr/bin/python3 --version
/usr/bin/gcc --version

$PYTHON --version

printf "Install package\n\n"
$PIP install .

printf "Install publication deps\n\n"
$PIP install twine semver

# Validate the version
$PYTHON /validate_version.py $REF

printf "Prepare for publication...\n\n"
$GIT clean -fxd
$PYTHON setup.py build sdist --format=gztar
TWINE=$(which twine)

printf "Publish...\n\n"
$TWINE upload $URL_ARG dist/*
