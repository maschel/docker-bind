# Dockerfile to run BIND DNS server container
# Based on Ubuntu Image
# Maschel ICT, Geoffrey Mastenbroek, 2017

# Use Ubuntu as base image
FROM ubuntu:xenial
MAINTAINER Geoffrey Mastenbroek

# Set environment variables
ENV BIND_VERSION=1:9.10.3 \
    BIND_USER=bind \
    DATA_DIR=/data

# Update repository and install packages
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y bind9=${BIND_VERSION}* bind9-host=${BIND_VERSION}* dnsutils \
 && rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Expose BIND ports
EXPOSE 53/udp 53/tcp

# Start bind
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
