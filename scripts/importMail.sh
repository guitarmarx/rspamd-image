#!/bin/bash
if [ "$(ls -A ${SPAM_IMPORT_FOLDER}/)" ]; then
    for file in ${SPAM_IMPORT_FOLDER}/*.eml; do
        rspamc learn_spam -h 127.0.0.1:80  $file
        status=$?

        if [ $status -eq 0 ]; then
            rm $file
        fi
    done
fi