#!/bin/bash

ls *.shp | sed -e 's/.shp//g' > fileshp.txt
for shpname in `cat fileshp.txt`; do
	## coordinate extraction
	ogrinfo -al ${shpname}.shp | grep " POINT " | sed -e 's/  POINT (//g' -e 's/  POINT [A-Z]* (//g' -e 's/)//g'  > xy.txt
	awk '{print $1,$2}' xy.txt > xy2.txt
	
	## titik dalam perum 50m
	# ogrinfo -al ${shpname}.shp | grep "  ELEVASI" | sed -e 's/  ELEVASI (Real) = //g'  > z.txt

	## titik dalam perum
	ogrinfo -al ${shpname}.shp | grep "  NIKDLM" | sed -e 's/  NIKDLM (Real) = //g'  > z.txt
	
	## garis pantai
	ogrinfo -al ${shpname}.shp | grep "  ELEVA" | sed -e 's/  ELEVASI (Real) = //g' -e 's/  ELEVATION (Real) = //g' >> z.txt
	
	# mengubah nilai + menjadi -
	awk '{print sqrt($1^2)*-1}' z.txt > z2.txt

	paste -d" " xy2.txt z2.txt > ${shpname}.txt
	rm xy.txt xy2.txt z.txt z2.txt
	
	## reference system extraction
	# ogrinfo -al ${shpname}.shp | grep "\[\"" | sed 's/\ //g' >> ${shpname}_SRS.txt
	
done
