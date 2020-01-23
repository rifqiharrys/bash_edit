####convert data BATNAS dari format tif ke grd
# cd latihan
# gdal_translate -of "NetCDF" BATNAS_115E-120E_05S-000_MSL_v1.1.tif input1.grd

# lon0=`awk 'BEGIN{a=1000}{if ($1<0+a) a=$1} END{print a}' masspoints_geo.txt`
# lat0=`awk 'BEGIN{a=1000}{if ($2<0+a) a=$2} END{print a}' masspoints_geo.txt`
# lonf=`awk 'BEGIN{a=   -1000}{if ($1>0+a) a=$1} END{print a}' masspoints_geo.txt`
# latf=`awk 'BEGIN{a=   -1000}{if ($2>0+a) a=$2} END{print a}' masspoints_geo.txt`

# lon0=`ogrinfo -al Border10.shp |grep "Extent" | sed 's/Extent: (//g' | sed 's/)//g' | sed 's/(//g' |sed -e 's/ - / /g' | sed -e 's/,//g'| awk '{print $1-0.05}'`
# lat0=`ogrinfo -al Border10.shp |grep "Extent" | sed 's/Extent: (//g' | sed 's/)//g' | sed 's/(//g' |sed -e 's/ - / /g' | sed -e 's/,//g'| awk '{print $2-0.05}'`
# lonf=`ogrinfo -al Border10.shp |grep "Extent" | sed 's/Extent: (//g' | sed 's/)//g' | sed 's/(//g' |sed -e 's/ - / /g' | sed -e 's/,//g'| awk '{print $3+0.05}'`
# latf=`ogrinfo -al Border10.shp |grep "Extent" | sed 's/Extent: (//g' | sed 's/)//g' | sed 's/(//g' |sed -e 's/ - / /g' | sed -e 's/,//g'| awk '{print $4+0.05}'`

lat0=`gdalinfo BATNAS_105E-110E_000-05N_MSL_v1.0.tif | grep "Lower Left" | awk -F "(" '{print $2}' | awk -F ", " '{print $2}' | sed -e 's/ //g' -e 's/)//g'`
lon0=`gdalinfo BATNAS_105E-110E_000-05N_MSL_v1.0.tif | grep "Lower Left" | awk -F "(" '{print $2}' | awk -F ", " '{print $1}' | sed 's/ //g'`
latf=`gdalinfo BATNAS_105E-110E_000-05N_MSL_v1.0.tif | grep "Upper Right" | awk -F "(" '{print $2}' | awk -F ", " '{print $2}' | sed -e 's/ //g' -e 's/)//g'`
lonf=`gdalinfo BATNAS_105E-110E_000-05N_MSL_v1.0.tif | grep "Upper Right" | awk -F "(" '{print $2}' | awk -F ", " '{print $1}' | sed 's/ //g'`

echo "Processing data dari $lon0 sampai $lonf dan dari $lat0 sampai $latf"

csh base_process.csh masspoint2_geo.txt input1.grd $lon0 $lonf $lat0 $latf 0.00007 0.00007 10
mv final_predicted.grd input1.grd
csh update.csh masspoint2_geo.txt input1.grd $lon0 $lonf $lat0 $latf 0.00005 0.00005 5
gdal_translate -of "GTiff" final_predicted.grd DTM_FINAL_5m.tif
