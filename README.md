# ISTART-socdoors: Social Doors Task Data and Analyses
This repository contains code related to our in prep project related to neural responses to social and monetary rewards. All hypotheses and analysis plans were pre-registered on AsPredicted in fall semester 2019 (https://aspredicted.org/blind.php?x=JNH_EGK) and data collection commenced on shortly thereafter. Imaging data will be shared via [OpenNeuro][openneuro] when the manuscript is posted on bioRxiv.


## A few prerequisites and recommendations
- Understand BIDS and be comfortable navigating Linux
- Install [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FslInstallation)
- Install [miniconda or anaconda](https://stackoverflow.com/questions/45421163/anaconda-vs-miniconda)


## Notes on repository organization and files
- Raw DICOMS (an input to heudiconv) are private and only accessible locally (Smith Lab Linux: /data/sourcedata)
- Some of the contents of this repository are not tracked (.gitignore) because the files are large and we do not yet have a nice workflow for datalad. These folders include `/data/sourcedata` (dicoms) and parts of `bids` and `derivatives`.
- Tracked folders and their contents:
  - `code`: analysis code
  - `templates`: fsf template files used for FSL analyses
  - `masks`: images used as masks, networks, and seed regions in analyses
  - `derivatives`: derivatives from analysis scripts, but only text files (re-run script to regenerate larger outputs)


## Basic commands to reproduce our analyses
```
# get code and data (two options for data)
git clone https://github.com/DVS-Lab/istart-socdoors
cd  istart-socdoors

rm -rf bids # remove bids subdirectory since it will be replaced below
# can this be made into a sym link?

datalad clone https://github.com/OpenNeuroDatasets/ds003745.git bids
# the bids folder is a datalad dataset
# you can get all of the data with the command below:
datalad get sub-*

# run preprocessing and generate confounds and timing files for analyses
bash code/run_fmriprep.sh
python code/MakeConfounds.py --fmriprepDir="derivatives/fmriprep"
bash code/run_gen3colfiles.sh

# run statistics
bash code/run_L1stats.sh
bash code/run_L2stats.sh
bash code/run_L3stats.sh

# generate hypothetical target ROIs for H2 (example for vmPFC)

# create a point at the peak voxel
fslmaths thresh_zstat1.nii.gz -mul 0 -add 1 -roi 33 1 61 1 19 1 0 1 point-vmpfc -odt float
# specify a sphere around that point
fslmaths point-vmpfc -kernel sphere 5 -fmean target-vmpfc -odt float
# binarize the sphere
fslmaths target-vmpfc -bin target-vmpfc_bin

# run permutation analysis for linear model
/data/tools/palm-alpha119/palm -i [CSV FILE WITH DATA] -d [DESIGN.MAT] -t [DESIGN.CON] -o [OUTPUT FILE] -corrcon -pearson -demean
```


## Acknowledgments
This work was supported, in part, by grants from the *National Institutes of Health (R03-DA046733 to DVS and R15-MH122927 to DSF)
*. DVS was a Research Fellow of the Public Policy Lab at Temple University during the preparation of the manuscript (2019-2020 academic year).

[openneuro]: https://openneuro.org/
