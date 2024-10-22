# stunnel-docker

# Docker Compose
```yaml
services:
    stunnel:
        image: ghcr.io/0xf00f00/stunnel:latest
        container_name: stunnel
        restart: unless-stopped
        ports:
            - "443:443"
        volumes:
            - ./stunnel:/etc/stunnel
```