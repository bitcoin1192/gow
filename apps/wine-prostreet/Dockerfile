# syntax=docker/dockerfile:1.4
ARG BASE_APP_IMAGE=ghcr.io/games-on-whales/base-app:fedora

FROM ${BASE_APP_IMAGE}

# Install Wine (64-bit & 32-bit), winetricks, cabextract, Xvfb, and Vulkan drivers
RUN dnf install -y --allowerasing \
        cabextract \
        mesa-vulkan-drivers mesa-vulkan-drivers.i686 \
        vulkan-loader vulkan-loader.i686 \
        wine wine.i686 \
        winetricks \
        xorg-x11-server-Xvfb \
    && dnf clean all

# Wine environment
ENV WINEPREFIX=/home/retro/.wine \
    WINEARCH=wow64 \
    WINEDEBUG=-all \
    WINEDLLOVERRIDES="dinput8=n,b;d3dx9_34=n,b" \
    XDG_RUNTIME_DIR=/tmp/.X11-unix

# Build template wineprefix with dxvk, vcruntime 2008-2015, and all fonts
RUN mkdir -p /opt/wineprefix-template /game /home/retro/.wine && \
    Xvfb :99 -screen 0 1024x768x24 & \
    XVFB_PID=$! && \
    export DISPLAY=:99 && \
    export WINEPREFIX=/opt/wineprefix-template && \
    wineboot --init && \
    wineserver -w && \
    winetricks -q dxvk vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 && \
    (winetricks -q allfonts || true) && \
    wineserver -w && \
    (kill $XVFB_PID 2>/dev/null || true) && \
    ln -sf /opt/wineprefix-template /wineprefix && \
    chown -R 1000:1000 /opt/wineprefix-template /game /home/retro && \
    chmod -R 777 /opt/wineprefix-template && \
    rm -rf /root/.cache /tmp/*

COPY --chmod=777 scripts/startup.sh /opt/gow/startup-app.sh

WORKDIR /game

ARG IMAGE_SOURCE
LABEL org.opencontainers.image.source=$IMAGE_SOURCE
