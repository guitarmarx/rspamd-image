#!/bin/sh

#crontab
echo "0 * * * * /srv/scripts/importMail.sh" | crontab -

##### RSPAMD CONFIG #####
WEB_PASSWORD=$(rspamadm pw -p $WEB_PASSWORD)
dockerize -template /srv/templates/modules/:/etc/rspamd/local.d/
dockerize -template /srv/templates/conf/:/etc/rspamd/local.d/

# add whitelists
echo $DOMAIN_WHITELIST | tr -s ',' '\n' > /etc/rspamd/local.d/whitelist.sender.domain.map
echo $IP_WHITELIST | tr -s ',' '\n' > /etc/rspamd/local.d/ip_whitelist.map

#permissions
mkdir -p /run/rspamd
chown -R rspamd:rspamd /run/rspamd
chown -R rspamd:rspamd /etc/rspamd/

# start cron
crond &

#### SERVICE START #####

# wait for redis
dockerize -wait tcp://$REDIS_SERVER:6379

rspamd --no-fork -u rspamd -g rspamd -c /etc/rspamd/rspamd.conf