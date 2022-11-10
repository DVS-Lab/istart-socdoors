#!/bin/bash

# compile PALM output into a single file

model=ppi_domain_x_outcome

for c in 1 2 3 4 5 6 7 8 9 10 11 12; do
	for s in tstat tstat_uncp tstat_fwep tstat_cfwep; do

		echo ${model}_dat_${s}_c${c}.csv
		cat ${model}_dat_${s}_c${c}.csv
	
	done
done
