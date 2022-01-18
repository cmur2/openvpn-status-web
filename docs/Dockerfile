FROM alpine:3.13

EXPOSE 8080

ENV VERSION=3.2.1

RUN apk --no-cache add openssl ca-certificates && \
    apk --no-cache add ruby ruby-etc ruby-webrick && \
    apk --no-cache add --virtual .build-deps ruby-dev build-base tzdata && \
    gem install --no-document openvpn-status-web -v ${VERSION} && \
    # set timezone to Berlin
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    apk del .build-deps

ENTRYPOINT ["openvpn-status-web", "/etc/openvpn-status-web/config.yml"]
