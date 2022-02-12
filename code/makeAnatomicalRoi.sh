#!/bin/bash

# define atlas
atlas = /usr/share/fsl/data/atlases/HarvardOxford/HarvardOxford-sub-maxprob-thr25-2mm.nii.gz

# This codes generates a mask in the desired region. 1) Adjust the threshold values based on indices from the atlas variable queried from the path above. 2) Adjust output name. 
# fslmaths $atlas -thr value -uthr value -bin output_name.

# Reference "Making ROIs" Slab page on DVS page.

fslmaths $atlas -thr 11 -uthr 11 -bin left_accumbens
fslmaths $atlas -thr 21 -uthr 21 -bin right_accumbens
fslmaths left_accumbens -add right_accumbens seed-NAcc
