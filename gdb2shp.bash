#!/bin/bash

ls -d ../*.gdb | sed -e 's/.gdb//g'| sed -e 's/\.\.//g' | sed -e 's/\///g' > filegdb.txt
for gdbname in `cat filegdb.txt`; do
	ogr2ogr -f "ESRI shapefile" ${gdbname} ../${gdbname}.gdb
done