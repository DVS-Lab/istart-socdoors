#!/bin/bash

# This script finds the number of signficant results and extracts them for single clusters 
# for comparisons between wins and losses for social + doors, ISTART 2022
# Jimmy Wyngaarden, August 2022

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
outputdir=${maindir}/derivatives/imaging_plots

for model in 2 3 4 5; do
	for type in "act" "nppi-dmn" "ppi_seed-VS_thr5"; do
		
		# Specify number of contrasts to evaluate based on model number
		if [ $model -eq 2 ]; then
			cnum=(3 4 5 6 7 8 9 10 11 12)
		fi
		if [ $model -eq 3 ]; then
			cnum=(3 4 5 6 7 8)
		fi
		if [ $model -eq 4 ]; then
			cnum=(3 4 5 6 7 8 9 10 11 12 13 14)
		fi
		if [ $model -eq 5 ]; then
			cnum=(3 4 5 6 7 8 9 10)
		fi		
		
		# Print the model number as a reference when reading through output
		echo "~~~~~~Model ${model}, type ${type}~~~~~~"
		echo " "
		
		for num in ${cnum[@]}; do			

			# For randomise models			
			for img in "clustere" "tfce" "vox"; do 
				for tfile in ${maindir}/derivatives/fsl/L3_model-${model}_task-socialdoors_n92_flame1+2_randomise/L3_model-${model}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/_${img}_corrp_tstat${num}.nii.gz; do
					fslmaths ${tfile} -thr .95 ${maindir}/derivatives/fsl/L3_model-${model}_task-socialdoors_n92_flame1+2_randomise/L3_model-${model}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/thresh_${img}_corrp_tstat${num}.nii.gz
					var=$(fslstats ${maindir}/derivatives/fsl/L3_model-${model}_task-socialdoors_n92_flame1+2_randomise/L3_model-${model}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/thresh_${img}_corrp_tstat${num}.nii.gz -R)
					yvar=$(echo ${var} | awk '{print $2}')
					if [ $yvar == "0.000000" ]; then
#						echo "No significant results for L3_model-${model}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/thresh_${img}_corrp_tstat${num}.nii.gz"
						rm ${maindir}/derivatives/fsl/L3_model-${model}_task-socialdoors_n92_flame1+2_randomise/L3_model-${model}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/thresh_${img}_corrp_tstat${num}.nii.gz
					fi
					if [ $yvar != "0.000000" ]; then
						fslmaths ${maindir}/derivatives/fsl/L3_model-${model}_task-socialdoors_n92_flame1+2_randomise/L3_model-${model}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/thresh_${img}_corrp_tstat${num}.nii.gz -bin ${maindir}/masks/15aug22_socialdoors_model-${model}_type-${type}_cnum-4_thresh_${img}_corrp_tstat${num}.nii.gz
						fslmeants -i ${maindir}/derivatives/fsl/L3_model-${model}_task-socialdoors_n92_flame1+2_randomise/L3_model-${model}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/type-${type}_model-${model}_randomise_filteredfunc_diff.nii.gz -o ${outputdir}/15aug22_task-socialdoors_model-${model}_type-${type}_cnum-4_thresh_${img}_corrp_tstat${num}.txt -m ${maindir}/masks/15aug22_socialdoors_model-${model}_type-${type}_cnum-4_thresh_${img}_corrp_tstat${num}.nii.gz
						echo "Significant cluster(s) found for thresh_${tfile}"					
					fi
				done
			done
			
			# For FLAME models
#			for file in ${maindir}/derivatives/fsl/L3_model-${model}_task-social+doors_n46_flame1+2/L3_task-social+doors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/cluster_mask_zstat${num}.nii.gz; do
#
#				# Find min and max for each cluster mask image
#				var=$(fslstats ${file} -R)			
#				#echo $file				
#				#echo $var
#				
#				# Isolate the max
#				yvar=$(echo ${var} | awk '{print $2}')
#				#echo "The number of clusters in the image is ${yvar}"
#				
#				# If the max = 1 (as it often does), there's only one cluster and it's already binarized, so you can go ahead and use it as a mask
#				if [ $yvar == "1.000000" ]; then
#					cp $file ${maindir}/masks/15aug22_social+doors_model-${model}_type-${type}_cnum-4_thresh-zstat${num}.nii.gz				
#					echo "Created binary mask for ${file}"	
#					
#					# Extract signal from mask
#					fslmeants -i ${maindir}/derivatives/fsl/L3_model-${model}_task-social+doors_n46_flame1+2/L3_task-social+doors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/filtered_func_data.nii.gz -o ${outputdir}/15aug22_task-social+doors_model-${model}_type-${type}_cnum-4_thresh-zstat${num}.txt -m ${file}
#					echo "Performed extraction for ${file} and wrote output to derivatives/imaging_plots"
#					echo " "				
#				fi				
#				
#				# If the max is not 1 or 0 then it must be greater than one
#				if [ $yvar != "1.000000" ] && [ $yvar != "0.000000" ]; then
#					echo "More than one cluster for ${file}"
#					
#					if [ $yvar == "2.000000" ]; then 
#						end=2 
#					fi
#					if [ $yvar == "3.000000" ]; then 
#						end=3 
#					fi
#					if [ $yvar == "4.000000" ]; then 
#						end=4
#					fi
#					if [ $yvar == "5.000000" ]; then 
#						end=5 
#					fi
#					if [ $yvar == "6.000000" ]; then 
#						end=6 
#					fi
#					if [ $yvar == "7.000000" ]; then 
#						end=7 
#					fi
#					length="$(seq $end)"
#					echo "$length"
#					
#					for i in $length; do
#						# Isolate each cluster							
#						fslmaths ${file} -uthr ${i} -thr ${i} -bin ${maindir}/derivatives/fsl/L3_model-${model}_task-social+doors_n46_flame1+2/L3_task-social+doors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/cluster_mask_zstat${num}_cluster-${i}.nii.gz
#							
#						# Extract signal from cluster
#						fslmeants -i ${maindir}/derivatives/fsl/L3_model-${model}_task-social+doors_n46_flame1+2/L3_task-social+doors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/filtered_func_data.nii.gz -o ${outputdir}/15aug22_task-social+doors_model-${model}_type-${type}_cnum-4_thresh-zstat${num}_cluster-${i}.txt -m ${maindir}/derivatives/fsl/L3_model-${model}_task-social+doors_n46_flame1+2/L3_task-social+doors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/cluster_mask_zstat${num}_cluster-${i}.nii.gz
#						echo "Performed extraction for ${file}, cluster ${i} and wrote output to derivatives/imaging_plots"
#						echo ${yint}							
#						echo " "								
#												
#					done		
#					echo " "	
#				fi				
#				
#			done
		done
	done
done


