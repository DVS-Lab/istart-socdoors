# example code for FMRIPREP
# runs FMRIPREP on input subject
# usage: bash run_fmriprep.sh sub
# example: bash run_fmriprep.sh 102

sub=$1

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# make derivatives folder if it doesn't exist.
# let's keep this out of bids for now
if [ ! -d $maindir/derivatives ]; then
	mkdir -p $maindir/derivatives
fi

scratchdir=/data/scratch/`whoami`
if [ ! -d $scratchdir ]; then
	mkdir -p $scratchdir
fi

TEMPLATEFLOW_DIR=/data/tools/templateflow
export SINGULARITYENV_TEMPLATEFLOW_HOME=/opt/templateflow
singularity run --cleanenv \
-B ${TEMPLATEFLOW_DIR}:/opt/templateflow \
-B $maindir:/base \
-B /data/tools/licenses:/opts \
-B $scratchdir:/scratch \
/data/tools/fmriprep-20.2.3.simg \
/base/bids /base/derivatives \
participant --participant_label $sub \
--stop-on-first-crash \
--fs-no-reconall --fs-license-file /opts/fs_license.txt -w /scratch
