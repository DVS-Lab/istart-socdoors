#!/bin/bash

# This run_* script is a wrapper for L3stats.sh, so it will loop over several
# copes and models. Note that Contrast N for PPI is always PHYS in these models.


# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"


# this loop defines the different types of analyses that will go into the group comparisons
for analysis in act ppi_seed-NAcc; do # act nppi-dmn nppi-ecn ppi_seed | type-${type}_run-01
	analysistype=type-${analysis}

	# these define the cope number (copenum) and cope name (copename)
	# for copeinfo in "1 C_pun" "2 C_rew" "3 F_pun" "4 F_rew" "5 S_pun" "6 S_rew"; do
	# "1 C_pun" "2 C_rew" "3 F_pun" "4 F_rew" "5 S_pun" "6 S_rew" "7 rew-pun" "8 F-S" "9 F-C" "10 FS-C" "11 rew-pun_F-S" "12 rew-pun_S-C" "13 rew-pun_F-C" "14 rew_F-S" "15 rew_S-C" "16 rew_F-C" "17 pun_F-S" "18 pun_S-C" "19 pun_F-C" "20 F-SC_all" "21 F-SC_rew" "22 F-SC_pun" "23 phys"; do
	for copeinfo in "1 C_pun" "2 C_rew" "3 F_pun" "4 F_rew" "5 S_pun" "6 S_rew" "7 rew-pun" "8 F-S" "9 F-C" "10 FS-C" "11 rew-pun_F-S" "12 rew-pun_S-C" "13 rew-pun_F-C" "14 rew_F-S" "15 rew_S-C" "16 rew_F-C" "17 pun_F-S" "18 pun_S-C" "19 pun_F-C" "20 F-SC_all" "21 F-SC_rew" "22 F-SC_pun" "23 phys" "24 F-SC_rew-pun"; do

		# split copeinfo variable
		set -- $copeinfo
		copenum=$1
		copename=$2

		if [ "${analysistype}" == "type-act" ] && [ "${copeinfo}" == "23 phys" ]; then
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

		NCORES=12
		SCRIPTNAME=${maindir}/code/L3stats.sh
		while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
			sleep 1s
		done
		bash $SCRIPTNAME $copenum $copename $analysistype &

	done
done
