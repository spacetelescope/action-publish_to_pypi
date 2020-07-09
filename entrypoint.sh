#!/bin/bash -l

set -e

# Publish to the PyPI testing instance URL if the env var 
# PYPI_TEST is set to a non-empty value, otherwise publish
# to the main index.
URL_ARG=""
if [[ "${PYPI_TEST}" != "" ]]; then
    echo "PYPI_TEST env var is set to a non-null value;"
    echo " twine call will publish to PyPI testing instance."
    URL_ARG="--repository-url https://test.pypi.org/legacy/"
fi

echo "U OVERRIDE: ${PYPI_USERNAME_OVERRIDE}"
if [[ "${PYPI_USERNAME_OVERRIDE}" != "" ]]; then
    echo "TWINE_USERNAME override using secrets value for this repository."
    TWINE_USERNAME=$PYPI_USERNAME_OVERRIDE
else
    TWINE_USERNAME=$PYPI_USERNAME_STSCI_MAINTAINER
fi
export TWINE_USERNAME

echo "P OVERRIDE: ${PYPI_PASSWORD_OVERRIDE}"
if [[ "${PYPI_PASSWORD_OVERRIDE}" != "" ]]; then
    echo "TWINE_PASSWORD override using secrets value for this repository."
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

echo "Install package"
$PIP install .

echo "Install publication deps"
$PIP install twine semver

# Validate the version
$PYTHON /validate_version.py $REF

echo "Prepare for publication..."
$GIT clean -fxd
$PYTHON setup.py build sdist --format=gztar
TWINE=$(which twine)

echo "Publish..."
$TWINE upload $URL_ARG dist/*
