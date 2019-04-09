#!/usr/bin/env bash

for f in  logs/*.log
do
	echo " ### $f ### "
	grep 'libcache gets:' $f | awk '{ total += $3 }END {print "libcache gets:", total }'
	grep 'libcache pins:' $f | awk '{ total += $3 }END {print "libcache pins:", total }'
	grep 'dc_objects:' $f | awk '{ total += $2 }END {print "dc_objects:", total }'
	grep 'dc_users:' $f | awk '{ total += $2 }END {print "dc_users:", total }'
done


