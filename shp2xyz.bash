ls *.shp | sed -e 's/.shp//g' > fileshp.txt
for shpname in `cat fileshp.txt`; do
	## coordinate extraction
	ogrinfo -al ${shpname}.shp | grep " POINT " | sed -e 's/  POINT (//g' -e 's/  POINT [A-Z]* (//g' -e 's/)//g'  > xy.txt
	awk '{print $1,$2}' xy.txt > xy_2.txt
	
	## titik dalam perum
	ogrinfo -al ${shpname}.shp | grep "NIKDLM" | sed -e 's/  NIKDLM (Real) = //g'  > z.txt
	
	## garis pantai
	ogrinfo -al ${shpname}.shp | grep "ELEVAS" | sed -e 's/  ELEVAS (Real) = //g'  >> z.txt
	
	paste -d" " xy_2.txt z.txt > ${shpname}.txt
	rm xy.txt xy_2.txt z.txt
	
    ## reference system extraction
	ogrinfo -al ${shpname}.shp | grep "\[\"" | sed 's/\ //g' >> ${shpname}_SRS.txt
	
done