#!/bin/sh

# import spam
if [ "$(ls -A ${SPAM_IMPORT_FOLDER}/)" ]; then
    mkdir -p ${SPAM_IMPORT_FOLDER}/learned
    for file in ${SPAM_IMPORT_FOLDER}/*.eml; do
        rspamc learn_spam -h 127.0.0.1:11334  $file
        status=$?

        if [ $status -eq 0 ]; then
            mv $file ${SPAM_IMPORT_FOLDER}/learned
        fi
    done
fi

# import ham
if [ "$(ls -A ${HAM_IMPORT_FOLDER}/)" ]; then
    mkdir -p ${HAM_IMPORT_FOLDER}/learned
    for file in ${HAM_IMPORT_FOLDER}/*.eml; do
        rspamc learn_ham -h 127.0.0.1:11334  $file
        status=$?

        if [ $status -eq 0 ]; then
            mv $file ${HAM_IMPORT_FOLDER}/learned
        fi
    done
fi
