#!/usr/bin/env bash
echo "Today is $(date)"
cd /Users/fpolig01/fran_misc/nas_cleanup/
source /Users/fpolig01/fran_misc/nas_cleanup/venv/bin/activate
python nas_cleanup.py
echo "Successfully ran NAS clean up script!"

