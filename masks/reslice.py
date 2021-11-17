#!/usr/bin/env python

# this script reslices an image based on a template.
# the images should be in exactly the same space
# this script will not perform any registration or normalization

# usage: python reslice.py input_img template_img output_img

# tip: use full paths


# import functions
import sys, os
from nilearn.image import resample_to_img, load_img
import nibabel as nib

input_img = sys.argv[1]
template_img = load_img(sys.argv[2])
output_img = resample_to_img(input_img,template_img)
outname = os.path.split(sys.argv[3])
nib.save(output_img,sys.argv[3])
fslmaths_out = os.path.join(outname[0],'thr_' + outname[1])
fslmaths_cmd = 'fslmaths ' + sys.argv[3] + ' -thr 0.5 -bin ' + fslmaths_out
os.system(fslmaths_cmd)
