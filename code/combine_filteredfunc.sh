#!/bin/bash

for slice in 0000 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046; do
	fslmaths /data/projects/istart-socdoors/derivatives/fsl/L3_task-faces_model-1_type-act_cov-RewSens_cope-4_n46_flame1+2.gfeat/cope1.feat/t${slice}.nii.gz -sub /data/projects/istart-socdoors/derivatives/fsl/L3_task-doors_model-1_type-act_cov-RewSens_cope-4_n46_flame1+2.gfeat/cope1.feat/t${slice}.nii.gz  filteredfunc_diff-${slice}
done