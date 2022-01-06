#!/bin/bash

# this will loop through all files in current directory with .log extension, then rename each .log file to .txt. 
for file in ./*.log
do
        mv "$file" "${file%.log}.txt"
done

exit