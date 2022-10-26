#!/usr/bin/env bash

FEDORA_VERSION=$(rpm -E %fedora)
FROM=registry.fedoraproject.org/fedora-toolbox:${FEDORA_VERSION}

podman run -ti --rm -v $(pwd):/target/ $FROM /bin/sh -c "\
    dnf install -y cmake gcc wayland-devel wayland-protocols-devel \
                    libwayland-client libwayland-egl \
                    mesa-libEGL mesa-libEGL-devel && \
    git clone --recurse-submodules https://github.com/Ferdi265/wl-mirror.git && \
    cd wl-mirror && \
    cmake -B build && make -C build &&
    cp -v build/wl-mirror /target/wl-mirror"

cp -v wl-mirror ~/bin/

