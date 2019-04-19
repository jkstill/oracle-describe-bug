#!/usr/bin/env bash

pScript='./desc2.pl'

# 18c
db='//192.168.1.93/orcl.jks.com'
# 19c
#db='//lestrade/p01.jks.com'

for db in '//192.168.1.93/orcl.jks.com' '//lestrade/p01.jks.com'
do

	echo
	echo "=== DESCRIBE - $db==="
	echo

	for i in $(seq 1 1)
	do
		./flush.sh $db
		time $pScript  --describe --database $db
	done

	echo
	echo "=== NO DESCRIBE - $db ==="
	echo

	for i in $(seq 1 1)
	do
		./flush.sh $db
		time $pScript --no-describe --database $db
	done

done

