#!/bin/bash -l

set -e

# Publish to the PyPI testing instance URL if the env var 
# TWINE_TEST is set to a non-empty value, otherwise publish
# to the main index.
URL_ARG=""
if [[ ${TWINE_TEST} != "" ]]; then
    echo "TWINE_TEST env var is set to a non-null value;"
    echo " twine call will publish to PyPI testing instance."
    URL_ARG="--repository-url https://test.pypi.org/legacy/"
fi

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
$PYTHON /validate_version.py ${REF}

echo "Prepare for publication..."
$GIT clean -fxd
$PYTHON setup.py build sdist --format=gztar
TWINE=$(which twine)

echo "Publish..."
$TWINE upload --repository-url https://test.pypi.org/legacy/ dist/*
$TWINE upload $URL_ARG dist/*
echo "${TWINE} upload ${URL_ARG} dist/*"
