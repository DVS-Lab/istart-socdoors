#!/bin/bash

task = socialdoors
for cope in 4; do
	for ppi in NAcc; do
		
		socialimage=/data/projects/istart-socdoors/derivatives/fsl/L3_task-faces_type-ppi_seed-${ppi}_n-100_cope-${cope}_flame1+2_indiv.gfeat/cope1.feat/filtered_func_data.nii.gz	
		nonsocialimage=/data/projects/istart-socdoors/derivatives/fsl/L3_task-doors_type-ppi_seed-${ppi}_n-100_cope-${cope}_flame1+2_indiv.gfeat/cope1.feat/filtered_func_data.nii.gz
		diffimage=/data/projects/istart-socdoors/derivatives/fsl/L3_task-socialdoors_type-ppi_seed-${ppi}_n-100_cope-${cope}_flame1+2_indiv/type-ppi_seed-${ppi}_cope-${cope}_filtered_func_diff.nii.gz
		matfile=/data/projects/istart-socdoors/derivatives/fsl/L3_task-faces_type-ppi_seed-${ppi}_n-100_cope-${cope}_flame1+2_indiv.gfeat/cope1.feat/design.mat
		confile=/data/projects/istart-socdoors/derivatives/fsl/L3_task-faces_type-ppi_seed-${ppi}_n-100_cope-${cope}_flame1+2_indiv.gfeat/cope1.feat/design.con	
		
		# make output directory		
		mkdir /data/projects/istart-socdoors/derivatives/fsl/L3_task-socialdoors_type-ppi_seed-${ppi}_n-100_cope-${cope}_flame1+2_indiv/
		outputdir=/data/projects/istart-socdoors/derivatives/fsl/L3_task-socialdoors_type-ppi_seed-${ppi}_n-100_cope-${cope}_flame1+2_indiv/
		
		# make filtered func diff image
		fslmaths $socialimage -sub $nonsocialimage $diffimage
		
		# cd to output dir
		cd $outputdir
		
		# run randomise
		randomise -i $diffimage -o $outputdir -d $matfile -t $confile -T
	done
done