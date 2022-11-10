#!/bin/bash

# compile PALM output into a single file

for i in *.csv; do

	echo $i
	cat $i

done
