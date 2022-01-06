#!/bin/bash

input="/home/fran/kafka.txt"

while IFS= read -r line
do
  	echo "$line"
done < "$input"

exit

