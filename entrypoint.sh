#!/bin/bash

_terminate() {
    echo "Caught SIGTERM signal!"
    kill -TERM "$redis_child" 2>/dev/null
    kill -TERM "$rspamd_child" 2>/dev/null
}
trap _terminate SIGTERM

##### REDIS CONFIG #######
#sed -i -- 's/bind 127.0.0.1/#bind 127.0.0.1/g' /etc/redis/redis.conf
sed -i -- "s/# maxmemory <bytes>/maxmemory $MAX_MEMORY/g" /etc/redis/redis.conf
sed -i -- "s/appendonly no/appendonly yes/g" /etc/redis/redis.conf

##### SPAM IMPORT CONFIG #####
#create spam import folder
mkdir -p $SPAM_IMPORT_FOLDER

# folder permissions
chown -R _rspamd:_rspamd /var/lib/rspamd
chmod -R 775 /var/lib/rspamd

##### RSPAMD CONFIG #####
#Konfigurieren von rspamd
cp /tmp/rspamd_templates/*  /etc/rspamd/local.d

DNS_GLOBAL=$DNS_GLOBAL envsubst < /tmp/rspamd_templates/options.inc.tmpl > /etc/rspamd/local.d/options.inc
WEB_PASSWORD=$(rspamadm pw -p $WEB_PASSWORD) envsubst < /tmp/rspamd_templates/worker-controller.inc.tmpl > /etc/rspamd/local.d/worker-controller.inc
#REJECT_VALUE=$REJECT_VALUE ADD_HEADER_VALUE=$ADD_HEADER_VALUE GREYLIST_VALUE=$GREYLIST_VALUE envsubst < /tmp/metrics.conf.tmpl > /etc/rspamd/local.d/metrics.conf


#### SERVICE START #####
echo "Rspamd wird gestartet"

service redis-server start
service rspamd start

redis_child=$(cat /run/redis/redis-server.pid)
rspamd_child=$(cat /run/rspamd/rspamd.pid)

tail -f /var/log/rspamd/rspamd.log &

while true; do

    if [ "$(ls -A ${SPAM_IMPORT_FOLDER}/)" ]; then
        for file in ${SPAM_IMPORT_FOLDER}/*.eml; do
            rspamc learn_spam -h 127.0.0.1:80  $file
            status=$?

            if [ $status -eq 0 ]; then
                rm $file
            fi
        done
        sleep 10
    fi
done


