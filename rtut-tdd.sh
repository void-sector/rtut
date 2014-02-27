#!/bin/bash

TESTDIR=${1:-"./test"}

inotifywait -m -r --format "%w%f" -e moved_to,create,modify . | while read line
do
    # Check if our file ends with .php
    REGEX=".php$"
    if [[ ! $line =~ $REGEX ]] ; then
        continue;
    fi


echo ${TESTDIR}
echo $line

    REGEX="^${TESTDIR}/"
    if [[ "$line" =~ $REGEX ]] ; then
        # File is inside test dir, do not convert
        TESTFILE="${line}"
    else
        # Convert normal file to a testfile
        TESTFILE=`echo "${TESTDIR}/$line" | sed -e 's/.php$/Test.php/'`
    fi

    # Test file is not found
    if [ ! -f "${TESTFILE}" ] ; then
        continue;
    fi

echo ${TESTFILE}

    phpunit ./test/${TESTFILE}
done
