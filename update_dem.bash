#!/bin/csh
#  D. Sandwell 08/08/07
#  modified by Sofian 27/09/18
#
#  Update the topography grid using some new trusted data.
#
# check the number of arguments
#
 if [ "$#" -ne 9 ]; then
  echo " Usage: update_grid topo.xyz topo_old.grd lon0 lonf lat0 latf dlon dlat edit"
  echo "        topo.xyz   -  file of lon, lat, depth (neg meters)"
  echo "        topo_old.grd - existing low resolution grid of topography"
  echo "        lon0       -  left boundary of output grid (0-360)" 
  echo "        lonf       -  right boundary of output grid (0-360)"
  echo "        lat0       -  lower boundary of output grid"
  echo "        latf       -  upper boundary of output grid"
  echo "        dlon       -  longitude spacing of output grid (e.g., .001)"
  echo "        dlat       -  latitude spacing of output grid"
  echo "        edit       _  remove |differences| > edit"
  echo " "
  echo "Example: bash update_dem.bash masspoint.xyz topo_old.grd 90 120 -15 15 .000075 .000075 10"
  exit
 fi
#
#  first blockmedian the input data to make the file smaller
#
gmt blockmedian $1 -R$3/$4/$5/$6 -I$7/$8 > block.xyz
#
#   make a matching grid from the global topo
#
gmt grd2xyz $2 -S > global.xyz
gmt surface global.xyz -R$3/$4/$5/$6 -I$7/$8 -T.00 -V -Gglobal.grd
#
#  interpolate the new data through the old grid
#
gmt grdtrack block.xyz -Gglobal.grd -S > predict.xyzz
#
awk '{if(!(($4-$3) > '$9' || ($3-$4) > '$9')) print($1, $2, $3-$4)}' < predict.xyzz > block.xyd
#
#   now make the difference grid
#
gmt surface block.xyd -R$3/$4/$5/$6 -I$7/$8 -T.15 -V -Gdiff.grd
#
#   add the two grids
#
gmt grdmath global.grd diff.grd ADD = final_DEM.grd
#
#  clean up the mess
#
#rm global.grd
