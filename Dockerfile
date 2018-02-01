# Dockerfile to run BIND DNS server container
# Based on Alpine Image
# Maschel ICT, Geoffrey Mastenbroek, 2018

# Use Alpine as base image
FROM alpine:latest
MAINTAINER Geoffrey Mastenbroek

# Set environment variables
ENV BIND_USER=named \
    DATA_DIR=/data

# Install apk's (cache disabled)
RUN apk --no-cache add bind bind-tools

# Copy entrypoint script
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Expose BIND ports
EXPOSE 53/udp 53/tcp

# Start bind
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
