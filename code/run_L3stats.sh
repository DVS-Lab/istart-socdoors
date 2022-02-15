#!/bin/bash

# This run_* script is a wrapper for L3stats.sh, so it will loop over several
# copes and models. Note that Contrast N for PPI is always PHYS in these models.


# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"


# this loop defines the different types of analyses that will go into the group comparisons
for TASK in doors socialdoors; do
#for COV in alcohol tobacco marijuana; do
for analysis in act; do # act ppi_seed-NAcc-act_n46 ppi_seed-vmpfc nppi-dmn nppi-ecn ppi_seed | type-${type}_run-01
	analysistype=type-${analysis}_run-1

	# these define the cope number (copenum) and cope name (copename)
	# for copeinfo in "1 C_pun" "2 C_rew" "3 F_pun" "4 F_rew" "5 S_pun" "6 S_rew"; do
	for copeinfo in "3 dec" "4 win-loss"; do

		# split copeinfo variable
		set -- $copeinfo
		copenum=$1
		copename=$2

		if [ "${analysistype}" == "type-act" ] && [ "${copeinfo}" == "5 phys" ]; then
			echo "skipping phys for activation since it does not exist..."
			continue
		fi

		# rename copeinfo variable for activation and ppi analyses
		if [ "${analysistype}" == "type-act" ] && [ "${copeinfo}" == "24 F-SC_rew-pun" ]; then
			copenum=23
			copename=F-SC_rew-pun
		elif [ "${analysistype}" == "type-ppi_seed-NAcc" ] && [ "${copeinfo}" == "24 F-SC_rew-pun" ]; then
			copenum=23
			copename=F-SC_rew-pun
		elif [ "${analysistype}" == "type-ppi_seed-NAcc" ] && [ "${copeinfo}" == "23 phys" ]; then
			copenum=24
			copename=phys
		fi

		NCORES=20
		SCRIPTNAME=${maindir}/code/L3stats.sh
		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
			sleep 1s
		done
		bash $SCRIPTNAME $copenum $copename $analysistype $TASK $COV &

	done
done
#done
done