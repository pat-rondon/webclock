#!/bin/bash

# USER-SERVICEABLE PARTS
CACHEDIR=/tmp/imgcache
CLOCKFILE=/tmp/clock.png
BACKGROUND=black
SIZE=350x240
WGETOPTS='-q -U "Mozilla/5.0"'
# END USER-SERVICEABLE PARTS

mkdir -p $CACHEDIR

digits=(zero one two three four five six seven eight nine)
teens=(ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
tens=(nothing nada twenty thirty forty fifty)

function englishnum {
  t=$(($1 / 10))
  o=$(($1 % 10))
  if [ $t -eq 0 ]; then
      echo -n ${digits[$o]}
  elif [ $t -eq 1 ]; then
      echo -n ${teens[$o]}
  elif [ $o -eq 0 ]; then
      echo -n ${tens[$t]}
  else
      echo -n "${tens[$t]}%20${digits[$o]}"
  fi
}

function fetchnum {
    FILENAME=$CACHEDIR/$1.jpg
    if [ ! -f $FILENAME ]; then
        wget $WGETOPTS -O - "http://images.google.com/images?sourceid=chrome&q=$1&um=1&ie=UTF-8&sa=N&hl=en&tab=wi" | \
            grep -o "\"http://[^\"]*.jpg\"" | \
            sort -R | \
            head -1 | \
            tr -d '"' | \
            wget $WGETOPTS -O $FILENAME -i -
    fi

    echo $FILENAME
}

MINUTES=`date +%M | sed "s/^0//"`
HOURS=`date +%k`

EMINUTES=`englishnum $MINUTES`
EHOURS=`englishnum $HOURS`

gm montage -background $BACKGROUND -geometry $SIZE `fetchnum $EHOURS` `fetchnum $EMINUTES` $CLOCKFILE
