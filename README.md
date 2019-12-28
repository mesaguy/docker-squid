# Alpine based squid service

[![DockerHub Badge](http://dockeri.co/image/mesaguy/squid)](https://hub.docker.com/r/mesaguy/squid)

## Introduction

Simple unprivileged squid implementation.

squid runs on 3128/tcp as the user 'squid', daemon logs are send to stderr, application usage logs are under /var/log/squid within the container

## Usage

The most basic usage is:

    docker run -t -p 3128 mesaguy/squid

Use a custom squid configuration file and mount squid's cache locally:

    mkdir cache
    chown 31:31 cache
    docker run -t -p 3128 -v $(pwd)/cache/:/var/cache/squid -v $(pwd)/squid.conf:/etc/squid/squid.conf:ro mesaguy/squid

Setup a SSL CA, create a myCA.der certificate for clients, use a custom configuration file, and intercept/decrypt https communication:

    mkdir cache
    sudo chown 31:31 cache
    openssl req -new -newkey rsa:2048 -sha256 -days 3650 -nodes -x509 -extensions v3_ca -keyout myCA.pem  -out myCA.pem
    openssl x509 -in myCA.pem -outform DER -out myCA.der
    sudo chown 31 myCA.pem
    docker run -t -p 3128 -v $(pwd)/cache/:/var/cache/squid -v $(pwd)/myCA.pem:/etc/squid/squid.pem:ro -v $(pwd)/squid-ssl-ca.conf:/etc/squid/squid.conf:ro mesaguy/squid

Clients will need to trust the myCA.pem certificate before this configuration can be used
