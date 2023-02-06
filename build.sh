#!/bin/bash

# Fixed branch name for our development
BRANCH="c1tenth-develop"

# Allow one to manually specify one or more images to build
OPTIONS=${@:1}

# Packages we want to build -- note that we must build in
# a specific
PACKAGES=${OPTIONS:-"carma-base            \
                     autoware.ai           \
                     carma-config          \
                     carma-messenger       \
                     carma-msgs            \
                     carma-platform        \
                     carma-web-ui"}

# Check out packages
vcs import . < c1tenth-develop.repos

# Pull the latest code
vcs pull .

# Build each package
for package in $PACKAGES
do
    pushd $package
    git checkout $BRANCH
    git pull
    ./docker/build-image.sh -v $BRANCH
    popd
done