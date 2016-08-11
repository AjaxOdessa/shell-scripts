#!/bin/sh

HOST="example.org"
PASS="mypassword"
BIT="4096"
DAYS="365"

ssl_info(){
	echo Country
	echo State
	echo City
	echo Company
	echo Department
	echo $HOST
	echo email@example.com
}

ssl_info | openssl req -x509 -nodes -days $DAYS -newkey rsa:$BIT -keyout $HOST.key -out $HOST.cer > /dev/null 2>&1
openssl pkcs12 -export -in $HOST.cer -inkey $HOST.key -password pass:$PASS > $HOST.p12
keytool -importkeystore -srckeystore $HOST.p12 -destkeystore $HOST.jks \
	-srcstorepass $PASS -deststorepass $PASS \
	-srcstoretype pkcs12 -deststoretype jks \
	-srcalias 1 -destalias $HOST \
	-srckeypass $PASS -destkeypass $PASS \
	-noprompt
rm -f $HOST.p12

