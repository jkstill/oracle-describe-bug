#!/usr/bin/env bash

pScript='./desc2.pl'

unset ORAENV_ASK
. /usr/local/bin/oraenv <<< c12

mkdir -p ./nyt

# 18c
db='//192.168.1.93/orcl.jks.com'

echo
echo "=== DESCRIBE - $db==="
echo

./flush/sh
export NYTPROF=trace=2:start=init:file=./nyt/nyt-18c-describe.out
perl -MDevel::NYTProf $pScript  --describe --database $db

echo
echo "=== NO DESCRIBE - $db ==="
echo

./flush/sh
export NYTPROF=trace=2:start=init:file=./nyt/nyt-18c-no-describe.out
perl -MDevel::NYTProf $pScript  --no-describe --database $db


# 19c
db='//lestrade/p01.jks.com'

echo
echo "=== DESCRIBE - $db==="
echo


./flush/sh
export NYTPROF=trace=2:start=init:file=./nyt/nyt-19c-describe.out
perl -MDevel::NYTProf $pScript  --describe --database $db

echo
echo "=== NO DESCRIBE - $db ==="
echo

# 19c
./flush/sh
export NYTPROF=trace=2:start=init:file=./nyt/nyt-19c-no-describe.out
perl -MDevel::NYTProf $pScript  --no-describe --database $db




