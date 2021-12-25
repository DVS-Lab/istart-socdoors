#!/bin/bash

# define atlas
atlas = /usr/share/data/harvard-oxford-atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr25-2mm.nii.gz

fslmaths $atlas -thr 10 -uthr 10 -bin seed-left_amygdala
fslmaths $atlas -thr 20 -uthr 20 -bin seed-right_amygdala