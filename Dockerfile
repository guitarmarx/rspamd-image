FROM debian:9.4-slim

LABEL maintainer="meteorIT GbR Marcus Kastner"

EXPOSE 11332 11333

ENV WEB_PASSWORD=test\
	SPAM_IMPORT_FOLDER=/tmp/spam \
	GLOBAL_DNS=46.38.252.230 \
	MAX_MEMORY=512mb

RUN apt update  \
	&& apt install -y wget lsb-release gnupg2 gettext redis-server \
	&& wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - \
	&& CODENAME=`lsb_release -c -s`\
	&& echo "deb http://rspamd.com/apt-stable/ $CODENAME main" > /etc/apt/sources.list.d/rspamd.list\
	&& echo "deb-src http://rspamd.com/apt-stable/ $CODENAME main" >> /etc/apt/sources.list.d/rspamd.list\
	&& apt update \
	&& apt install --no-install-recommends -y rspamd \
	&& rm -rf /var/lib/apt/lists/*

ADD * /tmp/

RUN chmod 755 /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
