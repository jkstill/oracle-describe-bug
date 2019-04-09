#!/usr/bin/env bash

# 18c
db='//192.168.1.93/orcl.jks.com'
# 19c
#db='//lestrade/p01.jks.com'

echo
echo "=== DESCRIBE - $db==="
echo

for i in $(seq 1 10)
do
	time ./desc.pl  --describe --database $db
done

echo
echo "=== NO DESCRIBE - $db ==="
echo

for i in $(seq 1 10)
do
	time ./desc.pl  --no-describe --database $db
done

