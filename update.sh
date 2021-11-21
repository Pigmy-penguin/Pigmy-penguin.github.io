#!/usr/bin/env bash

REPOS=$(curl -s https://api.github.com/users/Pigmy-penguin/repos | grep -wv '"name": "MIT\|GNU\|Other' | grep '"name\|description\|fork":')

echo "${REPOS}" | grep name | cut -d'"' -f4

