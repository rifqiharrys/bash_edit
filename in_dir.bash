#!/bin/bash

ls -d -- */ > filedir.txt
for dirname in `cat filedir.txt`; do
	cd "$dirname"

	#TODO: insert bash filename as argument
	$1

	cd ..
done