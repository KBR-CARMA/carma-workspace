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

# Setup the shared data
if [ ! -d /opt/carma ];
then
    echo ERROR: /opt folder not detected. Please run the follwing as root
    echo sudo curl -o /usr/bin/carma -L https://raw.githubusercontent.com/usdot-fhwa-stol/carma-platform/develop/engineering_tools/carma
    echo sudo chmod ugo+x /usr/bin/carma
    echo sudo curl -o /etc/bash_completion.d/__carma_autocomplete -L https://raw.githubusercontent.com/usdot-fhwa-stol/carma-platform/develop/engineering_tools/__carma_autocomplete
    echo sudo chmod ugo+x /etc/bash_completion.d/__carma_autocomplete
    echo curl -L https://raw.githubusercontent.com/usdot-fhwa-stol/carma-platform/develop/engineering_tools/opt_carma_setup.bash > opt_carma_setup.bash
    echo sudo bash opt_carma_setup.bash $PWD/carma-config/example_calibration_folder/vehicle
    echo rm opt_carma_setup.bash
else
    docker compose up --remove-orphans
fi