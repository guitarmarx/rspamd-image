#!/bin/sh

#crontab
echo "0 * * * * /srv/scripts/importMail.sh" | crontab -

##### RSPAMD CONFIG #####
WEB_PASSWORD=$(rspamadm pw -p $WEB_PASSWORD)
dockerize -template /srv/templates/:/etc/rspamd/local.d/

# add whitelist
echo $DOMAIN_WHITELIST | tr -s ',' '\n' > /etc/rspamd/local.d/whitelist.sender.domain.map

#permissions
mkdir -p /run/rspamd
chown -R rspamd:rspamd /run/rspamd
chown -R rspamd:rspamd /etc/rspamd/

# start cron
crond &

#### SERVICE START #####
rspamd --no-fork -u rspamd -g rspamd -c /etc/rspamd/rspamd.conf