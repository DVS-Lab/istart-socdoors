#!/bin/bash

# This script will perform Level 3 stats across social 
# and nonsocial conditions in the ISTART Social Doors task
# for models containing covariates

MAINDIR=/data/projects/start-socdoors

# Pull inputs from wrapper script run_randomise-socdoors.sh
SOCIALIMAGE=$1
NONSOCIALIMAGE=$2
MATFILE=$3
CONFILE=$4
CNUM=$5
CNAME=$6
N=$7
N2=$8
TYPE=$9
COV=$10

mkdir ${MAINDIR}/derivatives/fsl/L3_model-1_task-socialdoors_n100_flame1+2/L3_task-socialdoors_type-${TYPE}_run-1_n${N2}_cnum-${CNUM}_cname-${CNAME}_twogroup_cov-${COV}
OUTPUTDIR=${MAINDIR}/derivatives/fsl/L3_model-1_task-socialdoors_n100_flame1+2/L3_task-socialdoors_type-${TYPE}_run-1_n${N2}_cnum-${CNUM}_cname-${CNAME}_twogroup_cov-${COV}/
cd $OUTPUTDIR

# Create the difference image between social and nonsocial conditions
fslmaths $SOCIALIMAGE -sub $NONSOCIALIMAGE ${OUTPUTDIR}filtered_func_data_$COV_$CNUM.nii.gz
	
# Run randomise
cd $OUTPUTDIR
randomise -i $DIFFIMAGE -o $OUTPUTDIR -d $MATFILE -t $CONFILE -T

# End