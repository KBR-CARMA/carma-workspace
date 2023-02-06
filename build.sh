#!/bin/bash

OPTIONS=${@:1}
HUB="quitter.tech"
BRANCH="c1tenth-develop"
PACKAGES=${OPTIONS:-"carma-base            \
                     autoware.ai           \
                     carma-config          \
                     carma-messenger       \
                     carma-msgs            \
                     carma-platform"}

# vcs import . < c1tenth-develop.repos
# vcs pull .
for package in $PACKAGES
do
    pushd $package
    git checkout $BRANCH
    git pull
    ./docker/build-image.sh -v $BRANCH
    popd
done