
# Describe bug

Re a bug in 18c 'describe'

Inspired by this Jonathan Lewis blog:

https://jonathanlewis.wordpress.com/2019/04/08/describe-upgrade/

## Detailed Exe Profile

To use NYT Profiler: 

export NYTPROF=trace=2:start=init:file=/tmp/nytprof.out

see nyt.sh

## get libcache and rowcache stats

### stats.sh

Collects stats from an 18c and 19c db, both with/without use of 'describe'

### stat-totals.sh

get the totals of the stats from log files




