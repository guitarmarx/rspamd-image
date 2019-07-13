FROM alpine:3.10.0

LABEL maintainer="meteorIT GbR Marcus Kastner"

EXPOSE 11332 11333

ENV WEB_PASSWORD=password \
	SPAM_IMPORT_FOLDER=/srv/spam \
	GLOBAL_DNS=8.8.8.8 \
	MAX_MEMORY=512mb \
	DOMAIN_WHITELIST=''\
	DOCKERIZE_VERSION=v0.6.1 \
	REDIS_SERVER="<redisserver>"


RUN apk update \
	&& apk --no-cache add curl ca-certificates rspamd rspamd-controller curl \
	&&  rm -rf /var/cache/apk/*
#rsyslog

# download dockerize
RUN curl -L https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz --output /tmp/dockerize.tar.gz  \
	&& tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz \
	&& rm /tmp/dockerize.tar.gz

COPY templates /srv/templates
COPY scripts /srv/scripts

RUN mkdir -p $SPAM_IMPORT_FOLDER \
	&& chmod 755 /srv/scripts/*

ENTRYPOINT ["/srv/scripts/entrypoint.sh"]
