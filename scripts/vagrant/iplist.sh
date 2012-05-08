#!/bin/bash

echo "IP of the first host: "
read NAME

LASTNUM=${NAME##*.}
PRE=${NAME%.*}

echo "Number of hosts: "
read NUMBER
COUNT=1

echo "$NAME" > $NAME.list
until [ $COUNT -gt $NUMBER ]; do {
        let LASTNUM=LASTNUM+1
        echo "$PRE.$LASTNUM" >> $NAME.list
        let COUNT=COUNT+1
}
done
echo "$NAME.list created"

