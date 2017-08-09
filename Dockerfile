# Dockerfile to run BIND DNS server container
# Based on Ubuntu Image
# Maschel ICT, Geoffrey Mastenbroek, 2017

# Use Ubuntu as base image
FROM ubuntu
MAINTAINER Geoffrey Mastenbroek

# update repository and install packages
RUN apt-get update && apt-get install -y bind9 bind9utils bind9-doc
