FROM --platform=${TARGETPLATFORM} debian:stable-slim

WORKDIR /root

ARG TARGETPLATFORM
ARG VERSION

VOLUME /etc/stunnel

RUN set -eux; \
    apt-get update; \ 
    apt-get install -y --no-install-recommends wget binutils libssl-dev build-essential ca-certificates; \
    \
    export SOURCE_FILE="stunnel-${VERSION}"; \
    \
    echo "Downloading compressed release file..."; \
    wget -O /root/stunnel.tar.gz https://www.stunnel.org/downloads/${SOURCE_FILE}.tar.gz > /dev/null 2>&1; \
    if [ ! -f /root/stunnel.tar.gz ]; then \
        echo "Error: Failed to download compressed release file!"; exit 1; \
    fi; \
    echo "Download compressed release file completed."; \
    \
    mkdir -p /root/stunnel; \
    \
    echo "Extracting release file"; \
    tar -zxvf /root/stunnel.tar.gz -C /root; \
    if [ ! -d /root/${SOURCE_FILE} ]; then \
        echo "Error: Failed to extract release file!"; exit 1; \
    fi; \
    echo "Extracting release file: completed."; \
    \
    echo "Building stunnel..."; \
    cd /root/${SOURCE_FILE}; \
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-systemd; \
    make -j$(nproc); \
    echo "Building stunnel: completed."; \
    \
    echo "Installing stunnel..."; \
    make install; \
    echo "Installing stunnel: completed."; \
    \
    echo "Cleaning up..."; \
    cd /root; \
    rm -rf /root/stunnel.tar.gz /root/${SOURCE_FILE}; \
    apt-get remove -y wget binutils libssl-dev build-essential; \
    apt-get autoremove -y; \
    rm -rf /var/lib/apt/lists/*; \
    echo "Cleaning up: completed.";


CMD [ "/usr/bin/stunnel" ]
