#!/bin/bash
#
# Copyright 2022 United States Department of Transportation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Exit immediately on error
set -eo pipefail

# Fixed branch name for our development
BRANCH=${BRANCH:-"c1tenth-develop"}

# Allow one to manually specify one or more images to build
OPTIONS=${@:1}

# Packages we want to build -- note that we must build all packages in
# a specific order, so please don't change the list order below.
PACKAGES=${OPTIONS:-"carma-base            \
                     autoware.ai           \
                     carma-msgs            \
                     carma-platform        \
                     carma-web-ui          \
                     carma-config"}

# Build each package
for package in $PACKAGES
do
    docker pull quitter.tech/$package:$BRANCH
done

