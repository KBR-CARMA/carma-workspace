# Overview

This is a simple workspace management tool to help build the full CARMA stack for arm64. Unless you are compiling this on a Jetson board or on an arm64 instance in EC2, you'll almost certainly need to set up docker with QEMU support. You can do this in a VM or natively, but you will need root permission.

At a high-level what this script does is check out a fork of the official CARMA packages, hosted at `https://github.com/KBR-CARMA`. More specifically the branch `c1tenth-develop` which is made off of `develop`, with modifications for building on arm64, ie. different base images and package versions.

# Preparation

## Step 1: Setup your environment

Install Ubuntu 22.04 desktop natively or in a virtual machine. If you choose to do the latter, please make sure you have at least 100GB disk space and GPU acceleration enabled, at least 4 cores and 8GB of RAM to avoid any compilation errors.

See: [Ubuntu 22.04 Download](https://ubuntu.com/download/desktop)

Update and install a few utilities we'll need throughout the installation process:

```sh
[host] $ sudo apt update
[host] $ sudo apt upgrade
[host] $ sudo apt autoremove
[host] $ sudo apt install git curl python3-vcstool
```

## Step 2: Install and configure docker

See: [Installing Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

Next, make sure you add your username to the `docker` group:

```sh
[host] $ sudo usermod -aG docker $USER
```

Next, restart your host machine and make sure `docker` is in your groups.

```sh
[host] $ groups
```

Next, make sure that the docker daemon is running:

```sh
[host] $ sudo systemctl start docker.service
```

Finally, enable X11 forwarding from [this link](https://stackoverflow.com/q/48235040). This will allow X11 windows launched from a running docker container to appear on your host machine.

```sh
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
chmod 777 $XAUTH
```

## Step 3 : Add the NVIDIA docker runtime (Jetson ONLY)

Then, make sure you have the nvidia container runtime installed. This allows docker to expose your NVIDIA GPU to the container, so it can be used for ML-tasks.

```sh
[host] $ curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
    sudo apt-key add -
[host] $ curl -s -L https://nvidia.github.io/nvidia-container-runtime/ubuntu22.04/nvidia-container-runtime.list | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
[host] $ sudo apt update
[host] $ sudo apt install nvidia-cuda-toolkit nvidia-docker2 nvidia-container-runtime
```

Then add this to `/etc/docker/daemon.json` to make the nvidia runtime the default:

```json
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "default-runtime": "nvidia"
}
```

## Step 4: Install QEMU (only if your Development machine is x86 or x86_64)


See: [NVIDIA Installing QEMU](https://docs.nvidia.com/datacenter/cloud-native/playground/x-arch.html#installing-qemu)

Follow the steps in `Installing QEMU` to add an arm64 emulator.

# Building the docker images

On an Ubuntu machine all that is needed is to run ./build.sh to build the code. This will check out the `c1tenth-develop` fork of the CARMA code and the build the images versioned like `usdotfhwastol/carma-base:c1tenth-develop`, ie. by running `./docker/build-image.sh -v c1tenth-develop` on `carma-base`.

# Pushing the docker images to the jetson
