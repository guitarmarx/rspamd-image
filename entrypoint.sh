#!/bin/bash

#crontab
echo "0 * * * * /srv/scripts/importMail.sh" | crontab -

# start cron
crond &

##### RSPAMD CONFIG #####
WEB_PASSWORD=$(rspamadm pw -p $WEB_PASSWORD)

cp /srv/rspamd_templates/*  /etc/rspamd/local.d
dockerize -template /srv/templates/options.inc.tmpl:/etc/rspamd/local.d/options.inc
dockerize -template /srv/templates/worker-controller.inc.tmpl:/etc/rspamd/local.d/worker-controller.inc

#### SERVICE START #####
rspamd --no-fork -u rspamd -g rspamd -c /etc/rspamd/rspamd.conf