ARG ALPINE_VERSION=latest
ARG SOURCE_COMMIT
ARG VERSION=latest

FROM alpine:$ALPINE_VERSION

ENV SQUID_CONFIG_FILE /etc/squid/squid.conf

RUN apk add --no-cache squid && \
    mkdir -p /var/run/squid && \
    # Setup certificate generation
    /usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB && \
    chown -R squid:squid /run /var/lib/ssl_db

VOLUME ["/var/cache/squid"] 
EXPOSE 3128/tcp

USER squid

CMD ["sh", "-c", "/usr/sbin/squid -f ${SQUID_CONFIG_FILE} --foreground -z && exec /usr/sbin/squid -f ${SQUID_CONFIG_FILE} --foreground -YCd 1"]

LABEL org.label-schema.name="squid service" \
      org.label-schema.description="Simple unprivileged squid service built for many architectures" \
      org.label-schema.url="https://hub.docker.com/repository/docker/mesaguy/squid/" \
      org.label-schema.vcs-ref=$SOURCE_COMMIT \
      org.label-schema.vcs-url="https://github.com/mesaguy/docker-squid" \
      org.label-schema.vendor="Mesaguy" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
