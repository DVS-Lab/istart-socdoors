#!/bin/bash

SUB=$1

python3 downloadXNAT.py https://xnat.cla.temple.edu Smith-ISTART /data/sourcedata/istart/dicoms/ $SUB

mv /data/sourcedata/istart/dicoms/Smith-ISTART-$SUB/*/scans /data/sourcedata/istart/dicoms/Smith-ISTART-$SUB/
