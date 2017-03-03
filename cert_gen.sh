#!/bin/sh

# Setting variables
PASS="mypassword"
BIT="4096"
DAYS="365"

COUNTRY="UA"
STATE="State"
LOCALITY="City"
COMPANY="Company"
DEPARTMENT="Department"
HOST="example.org"
EMAIL="email@example.com"

ssl_info(){
	echo $COUNTRY; echo $STATE; echo $LOCALITY; echo $COMPANY; echo $DEPARTMENT; echo $HOST; echo $EMAIL
}
csr_info(){
	ssl_info; echo ""; echo ""
}

ssl_info | openssl req -x509 -nodes -days $DAYS -newkey rsa:$BIT -keyout $HOST.key -out $HOST.cer > /dev/null 2>&1
csr_info | openssl req -new -sha256 -key $HOST.key -out $HOST.csr > /dev/null 2>&1
openssl pkcs12 -export -in $HOST.cer -inkey $HOST.key -password pass:$PASS > $HOST.p12
keytool -importkeystore -srckeystore $HOST.p12 -destkeystore $HOST.jks \
	-srcstorepass $PASS -deststorepass $PASS \
	-srcstoretype pkcs12 -deststoretype jks \
	-srcalias 1 -destalias $HOST \
	-srckeypass $PASS -destkeypass $PASS \
	-noprompt
rm -f $HOST.p12
