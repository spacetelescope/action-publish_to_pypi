#!/usr/bin/env python3
# Perform a simple check on the tag portion of the git reference
# passed in as the first argument.

import sys
import semver

gitref = sys.argv[1]
print(f'\nVersion validation argument: {gitref}')
tag = gitref.split('/')[-1]
print(f'Tag: {tag}')
version = semver.VersionInfo.parse(tag)
print('Tag is a valid semver value.')
