ls -d -- */ | sed -e 's/\///g' > filefolder.txt
for foldername in `cat filefolder.txt`; do
	cd "$foldername"

	#TODO: insert argument

	cd ..
done