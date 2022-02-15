#!/bin/bash

# This script will perform Level 3 statistics in FSL.
# Rather than having multiple scripts, we are merging three analyses
# into this one script:
#		1) two groups (older vs. younger)
#		2) two groups (older vs. younger), with covariates
#		3) single group average
#
# This script can also run randomise (permutation-based stats) on existing output.
# By default, randomise will not be be run if FEAT analyses do not exist. In addition,
# randomise will only be run on copes above a specified number (see copenum_thresh_randomise variable).
# If you have no intention of running randomise, you set copenum_thresh_randomise=20 (> max of 19 copes)
# and you could uncomment out the rm lines that remove the filtered_func_data file (save disk space).

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# study-specific inputs and general output folder
N=50
copenum=$1
copenum_thresh_randomise=99 # actual contrasts start here. no need to do randomise main effects (e.g., reward > nothing/fixation/baseline)
copename=$2
REPLACEME=$3 # this defines the parts of the path that differ across analyses
TASK=$4
COV=$5
MAINOUTPUT=${maindir}/derivatives/fsl/L3_model-1_task-${TASK}_n${N}_flame1+2
mkdir -p $MAINOUTPUT


#### --- Two groups ------------------------------
# set outputs and check for existing
OUTPUT=${MAINOUTPUT}/L3_task-${TASK}_${REPLACEME}_cnum-${copenum}_cname-${copename}_twogroup
if [ -e ${OUTPUT}.gfeat/cope1.feat/cluster_mask_zstat1.nii.gz ]; then

	# run randomise if output doesn't exist and the contrasts (copes) are valid
	cd ${OUTPUT}.gfeat/cope1.feat
	if [ ! -e randomise_tfce_corrp_tstat4.nii.gz ] && [ $copenum -ge $copenum_thresh_randomise ]; then
		randomise -i filtered_func_data.nii.gz -o randomise -d design.mat -t design.con -m mask.nii.gz -T -c 2.6 -n 10000
	fi

else # try to run feat and clean up previous effort with partial output

	# echo "re-doing: ${OUTPUT}" >> re-runL3.log
	rm -rf ${OUTPUT}.gfeat

	# create template and run FEAT analyses
	# ITEMPLATE=${maindir}/templates/L3_template_n${N}_${TASK}_twogroup.fsf # TO DO: change to reward sensitivity covariate
	# OTEMPLATE=${MAINOUTPUT}/L3_task-${TASK}_${REPLACEME}_copenum-${copenum}_twogroup.fsf
	# sed -e 's@OUTPUT@'$OUTPUT'@g' \
	# -e 's@COPENUM@'$copenum'@g' \
	# -e 's@REPLACEME@'$REPLACEME'@g' \
	# -e 's@BASEDIR@'$maindir'@g' \
	# <$ITEMPLATE> $OTEMPLATE
	# feat $OTEMPLATE

	# delete unused files
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
	#rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz

fi


### --- Two groups with covariates ------------------------------
# set outputs and check for existing
OUTPUT=${MAINOUTPUT}/L3_task-${TASK}_${REPLACEME}_cnum-${copenum}_cname-${copename}_twogroup_wCovs
if [ -e ${OUTPUT}.gfeat/cope1.feat/cluster_mask_zstat1.nii.gz ]; then

	# run randomise if output doesn't exist and the contrasts (copes) are valid
	cd ${OUTPUT}.gfeat/cope1.feat
	if [ ! -e randomise_tfce_corrp_tstat4.nii.gz ] && [ $copenum -ge $copenum_thresh_randomise ]; then
		randomise -i filtered_func_data.nii.gz -o randomise -d design.mat -t design.con -m mask.nii.gz -T -c 2.6 -n 10000
	fi

else # try to run feat and clean up previous effort with partial output

	# echo "re-doing: ${OUTPUT}" >> re-runL3.log
	rm -rf ${OUTPUT}.gfeat

	# create template and run FEAT analyses
	# ITEMPLATE=${maindir}/templates/L3_template_n${N}_${TASK}_twogroup_wCovs.fsf # TO DO: change to reward sensitivity covariate
	# OTEMPLATE=${MAINOUTPUT}/L3_task-${TASK}_${REPLACEME}_copenum-${copenum}_twogroup_wCovs.fsf
	# sed -e 's@OUTPUT@'$OUTPUT'@g' \
	# -e 's@COPENUM@'$copenum'@g' \
	# -e 's@REPLACEME@'$REPLACEME'@g' \
	# -e 's@BASEDIR@'$maindir'@g' \
	# <$ITEMPLATE> $OTEMPLATE
	# feat $OTEMPLATE

	# delete unused files
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
	#rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
	rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz

fi



### --- One group ------------------------------
# set outputs and check for existing
OUTPUT=${MAINOUTPUT}/L3_task-${TASK}_${REPLACEME}_cnum-${copenum}_cname-${copename}_onegroup
if [ -e ${OUTPUT}.gfeat/cope1.feat/cluster_mask_zstat1.nii.gz ]; then

	# run randomise if output doesn't exist and the contrasts (copes) are valid
	cd ${OUTPUT}.gfeat/cope1.feat
	if [ ! -e randomise_tfce_corrp_tstat2.nii.gz ] && [ $copenum -ge $copenum_thresh_randomise ]; then
		randomise -i filtered_func_data.nii.gz -o randomise -d design.mat -t design.con -m mask.nii.gz -T -c 2.6 -n 10000
	fi

else # try to run feat and clean up previous effort with partial output

	echo "re-doing: ${OUTPUT}" >> re-runL3.log
	rm -rf ${OUTPUT}.gfeat

	# create template and run FEAT analyses
	ITEMPLATE=${maindir}/templates/L3_template_n${N}.fsf
	OTEMPLATE=${MAINOUTPUT}/L3_task-${TASK}_${REPLACEME}_copenum-${copenum}.fsf
	sed -e 's@OUTPUT@'$OUTPUT'@g' \
	-e 's@COPENUM@'$copenum'@g' \
	-e 's@REPLACEME@'$REPLACEME'@g' \
	-e 's@BASEDIR@'$maindir'@g' \
	3-e 's@TASK@'$TASK'@g' \
	<$ITEMPLATE> $OTEMPLATE
	feat $OTEMPLATE

fi

# delete unused files
rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/res4d.nii.gz
rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/corrections.nii.gz
rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/stats/threshac1.nii.gz
#rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/filtered_func_data.nii.gz
rm -rf ${OUTPUT}.gfeat/cope${cope}.feat/var_filtered_func_data.nii.gz
