#!/bin/bash

t0=`timedatectl | grep "Local time" | sed -e 's/                      Local time: //g'`

./$1

t1=`timedatectl | grep "Local time" | sed -e 's/                      Local time: //g'`

echo $t0 - $t1