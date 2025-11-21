####convert data BATNAS dari format tif ke grd
# setup filename and path
dir=../dem_update/data/
fname0=`ls $dir | grep "BATNAS"`
fpath0=$dir$fname0
fpath1=$dir"DEM_INTEGRASI_TOGEAN_10m_FINAL.tif"

gdal_translate -of "NetCDF" $fpath0 input1.grd

# lon0=`awk 'BEGIN{a=1000}{if ($1<0+a) a=$1} END{print a}' masspoints_geo.txt`
# lat0=`awk 'BEGIN{a=1000}{if ($2<0+a) a=$2} END{print a}' masspoints_geo.txt`
# lonf=`awk 'BEGIN{a=   -1000}{if ($1>0+a) a=$1} END{print a}' masspoints_geo.txt`
# latf=`awk 'BEGIN{a=   -1000}{if ($2>0+a) a=$2} END{print a}' masspoints_geo.txt`

# lon0=`ogrinfo -al Border10.shp |grep "Extent" | sed 's/Extent: (//g' | sed 's/)//g' | sed 's/(//g' |sed -e 's/ - / /g' | sed -e 's/,//g'| awk '{print $1-0.05}'`
# lat0=`ogrinfo -al Border10.shp |grep "Extent" | sed 's/Extent: (//g' | sed 's/)//g' | sed 's/(//g' |sed -e 's/ - / /g' | sed -e 's/,//g'| awk '{print $2-0.05}'`
# lonf=`ogrinfo -al Border10.shp |grep "Extent" | sed 's/Extent: (//g' | sed 's/)//g' | sed 's/(//g' |sed -e 's/ - / /g' | sed -e 's/,//g'| awk '{print $3+0.05}'`
# latf=`ogrinfo -al Border10.shp |grep "Extent" | sed 's/Extent: (//g' | sed 's/)//g' | sed 's/(//g' |sed -e 's/ - / /g' | sed -e 's/,//g'| awk '{print $4+0.05}'`

lat0=`gdalinfo $fpath0 | grep "Lower Left" | awk -F "(" '{print $2}' | awk -F ", " '{print $2}' | sed -e 's/ //g' -e 's/)//g'`
lon0=`gdalinfo $fpath0 | grep "Lower Left" | awk -F "(" '{print $2}' | awk -F ", " '{print $1}' | sed 's/ //g'`
latf=`gdalinfo $fpath0 | grep "Upper Right" | awk -F "(" '{print $2}' | awk -F ", " '{print $2}' | sed -e 's/ //g' -e 's/)//g'`
lonf=`gdalinfo $fpath0 | grep "Upper Right" | awk -F "(" '{print $2}' | awk -F ", " '{print $1}' | sed 's/ //g'`

echo "Processing data dari $lon0 sampai $lonf dan dari $lat0 sampai $latf"

csh base_process.csh $fpath1 input1.grd $lon0 $lonf $lat0 $latf 0.00007 0.00007 10
mv final_predicted.grd input1.grd
csh update.csh $fpath1 input1.grd $lon0 $lonf $lat0 $latf 0.00005 0.00005 5
# bash update_dem.bash $fpath1 input1.grd $lon0 $lonf $lat0 $latf 0.00005 0.00005 5
gdal_translate -of "GTiff" final_predicted.grd $dir"DTM_FINAL.tif"
