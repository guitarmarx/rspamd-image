# Kopano-Image

this docker image contains rspamd, an anti spam agent including a simple web gui.

## Usage

#### Build Image
```sh
git clone https://github.com/guitarmarx/rspamd-image.git
cd rspamd-image
docker build -t rspamd .
```
#### Run Container
```sh
docker run -d \
        -e WEB_PASSWORD=$RSPAMD_PASSWORD \
        -e REDIS_SERVER=${Umgebung}_redis \
        -v <your-path>:/var/lib/rspamd/ \
        <image>
```

# Configuration
#### Parameters:
Parameter | Function| Default Value|
---|---|---|
DB_HOST|database host|



#### Ports
 The following ports can be exposed:

Port | Function
--- | --- |
80 |http|
993|imap|
2003|lmtp|



#### Spam export
Every day at 01:00 there will be an automatic spam export to **/tmp/spamexport**. Every Mail of the last 24h from every user account will be copied to this to this folder as EML-File. You can persist the folder for further spam evaulation for example to train spam detection.


WEB_PASSWORD=password \
	SPAM_IMPORT_FOLDER=/srv/spam \
	GLOBAL_DNS=8.8.8.8 \
	MAX_MEMORY=512mb \
	DOMAIN_WHITELIST=''\
	DOCKERIZE_VERSION=v0.6.1 \
	REDIS_SERVER="<redisserver>" \
	REJECT_VALUE=15 \
	ADD_HEADER_VALUE=6 \
	GREYLIST_VALUE=4



