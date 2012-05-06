#!/bin/bash

echo "Hostname: "
read NAME

echo "Domain: "
read DOMAIN

echo "Number of $NAME.$DOMAIN hosts: "
read NUMBER
COUNT=1

echo "$NAME.$DOMAIN" > $NAME.list
until [ $COUNT -gt $NUMBER ]; do {
	echo "$NAME-$COUNT.$DOMAIN" >> $NAME.list
	let COUNT=COUNT+1
}
done
echo "$NAME.list created"
