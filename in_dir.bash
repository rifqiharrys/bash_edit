#!/bin/bash

cd /mnt/d/Kegiatan/PENGELOLAHAN_BATNAS/DATA_SHP/
ls -d -- */ > filedir.txt
for dirname in `cat filedir.txt`; do
	cd "$dirname"

	#TODO: insert bash filename as argument
	bash $1

	cd ..
done