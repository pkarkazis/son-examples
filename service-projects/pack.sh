#!/bin/bash

# CI entry point
# automatic packing of service projects to validate them
# (uses son-cli tools installed directly from git)

# be sure that old runs do not break things
rm -rf test_ws son-cli

set -e

git clone https://github.com/sonata-nfv/son-cli.git
cd son-cli
virtualenv -p /usr/bin/python3.4 venv
source venv/bin/activate
python bootstrap.py
bin/buildout
python setup.py develop
cd ..

# create a test workspace
son-workspace --init --workspace test_ws

# package all example service projects
which son-package
# emulator projects
son-package --workspace test_ws --project sonata-empty-service-emu -n sonata-empty-service
son-package --workspace test_ws --project sonata-snort-service-emu -n sonata-snort-service
son-package --workspace test_ws --project sonata-sdk-test-service-emu -n sonata-sdk-test-service
son-package --workspace test_ws --project sonata-vtc-service-emu -n sonata-vtc-service
son-package --workspace test_ws --project sonata-fw-vtc-service-emu -n sonata-fw-vtc-service
son-package --workspace test_ws --project sonata-fw-dpi-service-emu -n sonata-fw-dpi-service
son-package --workspace test_ws --project sonata-ovs-service-emu -n sonata-ovs-service
son-package --workspace test_ws --project sonata-fw-service-emu -n sonata-fw-service

# service platform projects
son-package --workspace test_ws --project sonata-fw-vtc-service-sp -n sonata-fw-vtc-service-sp
son-package --workspace test_ws --project sonata-fw-vtc-service-update-sp -n sonata-fw-vtc-service-update-sp

# leave venv
deactivate

# remove test workspace
rm -rf test_ws

# remove son-cli
rm -rf son-cli

# Note: The packaged services are not yet uploaded anywhere. We use packaging only to validate the service projects and their descriptors.
