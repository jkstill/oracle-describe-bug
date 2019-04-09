#!/usr/bin/env bash

mkdir -p logs

timesToRun=10

iterations=10000

# 18c
db='//192.168.1.93/orcl.jks.com'

logfile=logs/18c-describe.log

echo >$logfile
echo "=== DESCRIBE - $db===" >> $logfile
echo >> $logfile

for i in $(seq 1 $timesToRun)
do
	{ time ./desc.pl  --describe --database $db --iterations $iterations ;}  2>&1
	echo
done >> $logfile

logfile=logs/18c-no-describe.log

echo > $logfile
echo "=== NO DESCRIBE - $db ===" >> $logfile
echo >> $logfile

for i in $(seq 1 $timesToRun)
do
	{ time ./desc.pl  --no-describe --database $db --iterations $iterations ;}  2>&1
	echo
done >> $logfile

# 19c
db='//lestrade/p01.jks.com'

logfile=logs/19c-describe.log

echo > $logfile
echo "=== DESCRIBE - $db===" >> $logfile
echo >> $logfile

for i in $(seq 1 $timesToRun)
do
	{ time ./desc.pl  --describe --database $db --iterations $iterations ;}  2>&1
	echo
done >> $logfile

logfile=logs/19c-no-describe.log

echo > $logfile
echo "=== NO DESCRIBE - $db ===" >> $logfile
echo >> $logfile

for i in $(seq 1 $timesToRun)
do
	{ time ./desc.pl  --no-describe --database $db --iterations $iterations ;}  2>&1
	echo
done >> $logfile


