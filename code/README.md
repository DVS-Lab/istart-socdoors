# ISTART-data: Analysis Code

## Overview and disclaimers
- run_* scripts loop through a list of subjects for a given script; e.g., run_fmriprep.sh loops all subjects through the fmriprep.sh script.
- paths to input/output data should work without error, but check package/software installation

## Scripts used to generate public data
Some files cannot be shared publicly. And some raw source data are in non-standard format. The scripts below helped us go from the raw source data to the standardized public data:
- `prepdata.sh` -- runs [heudiconv](https://github.com/nipy/heudiconv) to convert dicoms to BIDS, defaces structural scans with pydeface, and runs [mriqc](https://mriqc.readthedocs.io/en/latest/index.html)
  - [heuristics.py](https://github.com/DVS-Lab/srndna-data/blob/main/code/heuristics.py) sets the heuristics for heudiconv
  - [addIntendedFor.py](https://github.com/DVS-Lab/srndna-data/blob/main/code/addIntendedFor.py) adds the "IntendedFor" field for the fmap files
- Code for stimuli control/presentation and conversion of raw behavioral data to BIDS are in [stimuli](https://github.com/DVS-Lab/srndna-data/tree/main/stimuli)

## Analyses  
- Analysis scripts are in task-specific repositories
- e.g., https://github.com/DVS-Lab/srndna-trustgame




[fmriprep]: http://fmriprep.readthedocs.io/en/latest/index.html
