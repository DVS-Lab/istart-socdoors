#!/bin/bash

# Script to copy NM dicom images to a folder to be shared with SDN Lab
for sub in 1001 1002 1003 1004 1006 1007 1009 1010 1011 1012 1013 1015 1016 1019 1021 1240 1242 1243 1244 1245 1247 1248 1249 1251 1253 1255 1276 1282 1286 1294 1300 1301 1302 1303 3101 3116 3122 3125 3140 3143 3152 3164 3166 3167 3170 3173 3175 3176 3186 3189 3190 3199 3200 3206 3210 3212 3218 3220 3223; do
	dcm_directory=/data/sourcedata/istart/dicoms/Smith-ISTART-${sub}/scans/*Neuromel*/	
	if test -d ${dcm_directory}; then
		echo "sub-${sub} NM file exists. Copying to ISTART folder."
		if test -d /data/projects/istart-socdoors/nm_dicoms/Smith-ISTART-${sub}; then
			echo "--this sub has already been copied over."
		else
			istart_directory=/data/projects/istart-socdoors/nm_dicoms/Smith-ISTART-${sub}/		
			mkdir ${istart_directory}
			mkdir ${istart_directory}/scans
			cp -r ${dcm_directory} ${istart_directory}/scans
			echo "--sub successfully copied to ISTART folder."
		fi
	else
		echo "sub-${sub} NM file does not exist."
	fi
done