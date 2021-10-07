"""
XNAT download app, Caleb Haynes 2021
req v python > 3.5 & xnat: python3 -m pip install xnat
usage: python3 downloadXNAT.py <url> <session> <outputDir>
log into xnat server, download scans
"""
import getpass
import os
import subprocess
import glob
import sys

try:
    import xnat
except ImportError:
    raise ImportError(
        """
        Module for XNAT not found- Run the following command:
        \n\n python3 -m pip install xnat"""
    )
os.umask(0)
url = sys.argv[1]
session = sys.argv[2]
outputDir = sys.argv[3]
subject = sys.argv[4]

# Enter subject number, username and password to retrieve scans


def download_sub(url, session, outputDir, subject):
    user = input("Enter Your XNAT Username\n\n>> ")
    password = getpass.getpass("Enter Your XNAT Password\n\n>> ")
    with xnat.connect(url, user, password) as connect:
        for sub in connect.projects[session].subjects.values():
            if subject in sub.label:
                print("Downloading...")
                sub.download_dir(outputDir)
    return

download_sub(url, session, outputDir, subject)
