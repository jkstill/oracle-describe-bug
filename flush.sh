#!/usr/bin/env bash

db="$1"

[[ -z $db ]] && {
	echo
	echo Please supply database name
	echo
	exit 1
}

unset SQLPATH

sqlplus -s /@$db <<-EOF
set term off feed off

alter system flush shared_pool;
exit

EOF
