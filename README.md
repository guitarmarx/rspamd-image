# RSPAMD-Image

this docker image runs rspamd in porxy mode, an anti spam agent including a simple web gui.
To use this image you need a running redis server.

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
        -p 11332:11332 \
        -p 11334:11334 \
        -e WEB_PASSWORD=<password> \
        -e REDIS_SERVER=<redis host name> \
        -v <your-path>:/var/lib/rspamd/ \
        <image>

```

### Ports
- 11332: port for postfix connection
- 11334: http port

# Configuration
#### Parameters:
Parameter | Function| Default Value|
---|---|---|
REDIS_SERVER | (optional) redis host name |
WEB_PASSWORD | (optional) password for http access on port 11332 | password
SPAM_IMPORT_FOLDER | (optional) folder to import spam mails, experimental | /srv/spam
GLOBAL_DNS | (optional) interal dns server | 8.8.8.8
MAX_MEMORY | (optional) maximum memory usage | 512mb
DOMAIN_WHITELIST | (optional) comma separated domain whitlisting |
REJECT_VALUE | (optional) threshold to reject mails | 12
ADD_HEADER_VALUE | (optional) threshold to add spam header | 6
GREYLIST_VALUE | (optional) threshold for geylisting | 4









