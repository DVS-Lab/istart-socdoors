#!/usr/bin/env bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# base paths
for TASK in social+doors; do
#for TASK in socialdoors; do
	MAINOUTPUT=${maindir}/derivatives/fsl/L3_model-1_task-${TASK}_n46_flame1+2
	outputdir=${maindir}/derivatives/imaging_plots
	mkdir -p $outputdir
	
	for ROI in mask_model-3_task-social+doors_type-ppi_seed-VS_thr5_thresh_zstat3_post-central-gyrus_bin; do #mask_model-3_type-nppi-dmn_cnum-4_vox_corrp_tstat5_putamen
	#for ROI in hyp-mask_sphere_dmpfc_bin hyp-mask_sphere_amygdala_bin hyp-mask_sphere_pcc_bin hyp-mask_sphere_right-FFA_bin hyp-mask_sphere_vmpfc_bin; do
		#for MODELNUM in 3; do		
		#for MODELNUM in 3; do

			MASK=${maindir}/masks/${ROI}.nii.gz
			for TYPE in ppi_seed-VS_thr5; do #act #ppi_seed-VS_thr5
		
				#for COPEINFO in "1 win" "2 loss"; do 
				for COPEINFO in "4 win-loss"; do			
			
					set -- $COPEINFO
					COPENUM=$1
					COPENAME=$2
			
					DATA=`ls -1 ${MAINOUTPUT}/L3_task-${TASK}_type-${TYPE}_cnum-${COPENUM}_cname-${COPENAME}_flame1+2.gfeat/cope1.feat/filtered_func_data.nii.gz`
					#DATA=`ls -1 ${MAINOUTPUT}/L3_task-${TASK}_type-${TYPE}_cnum-${COPENUM}_cname-${COPENAME}_flame1+2_twogroup.gfeat/cope1.feat/filtered_func_data.nii.gz`			
					fslmeants -i $DATA -o ${outputdir}/${ROI}_task-${TASK}_type-${TYPE}_cope-${COPENUM}.txt -m ${MASK}
			
				done			
			done
		done
	#done
done	

# tangential to paper, but could still add to neurovault
# conn_rFPN_precun.nii.gz
# conn_rFPN_VLPFC.nii.gz

# connectivity: ROI name and other path information
#for seedROI in "leftVS dACC" "leftVS LPFC" "leftVS visual" "rightVS dACC" "rightVS dPrecun" "rightVS vPrecun" "rightVS VMPFC_cov" "rightVS DLPFC_cov"; do
#	set -- $seedROI
#	seed=$1
#	ROI=$2
#	TYPE=ppi_seed-${seed}
#	MASK=${maindir}/masks/singletrial-masks/conn_${seed}_${ROI}.nii.gz
#	for COPENUM in 11 12 13 14; do
#		cnum_padded=`zeropad ${COPENUM} 2`
#		DATA=`ls -1 ${MAINOUTPUT}/L3_task-${TASK}_type-${TYPE}_cnum-${cnum_padded}_*.gfeat/cope1.feat/filtered_func_data.nii.gz`
#		fslmeants -i $DATA -o ${outputdir}/${ROI}_type-${TYPE}_cope-${cnum_padded}.txt -m ${MASK}
#	done
#done


# connectivity: ROI name and other path information (flipped to check laterality)
#for seedROI in "leftVS dACC" "leftVS LPFC" "leftVS visual" "rightVS dACC" "rightVS dPrecun" "rightVS vPrecun" "rightVS VMPFC_cov" "rightVS DLPFC_cov"; do
#	set -- $seedROI
#	seed=$1
#	ROI=$2
#	if [ "$seed" == "leftVS" ]; then
#		seed_flipped=rightVS
#	elif [ "$seed" == "rightVS" ]; then
#		seed_flipped=leftVS
#	else
#		echo "no match for $seed, so exiting..."
#	fi
#	TYPE=ppi_seed-${seed_flipped}
#	MASK=${maindir}/masks/singletrial-masks/conn_${seed}_${ROI}.nii.gz
#	for COPENUM in 11 12 13 14; do
#		cnum_padded=`zeropad ${COPENUM} 2`
#		DATA=`ls -1 ${MAINOUTPUT}/L3_task-${TASK}_type-${TYPE}_cnum-${cnum_padded}_*.gfeat/cope1.feat/filtered_func_data.nii.gz`
#		fslmeants -i $DATA -o ${outputdir}/${ROI}_type-${TYPE}_cope-${cnum_padded}_flipped.txt -m ${MASK}
#	done
#done
