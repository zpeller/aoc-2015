#!/bin/bash

downs=`tr -d '(' < 01.txt |wc -c`
ups=`tr -d ')' < 01.txt |wc -c`

echo $((ups-downs))

sed 's/\(.\)/\1\n/g' < 01.txt |\
awk 'BEGIN {level=0;}
		/\)/ {level--; if (level==-1) {print NR; exit;} }
		/\(/ {level++; if (level==-1) {print NR; exit;} }
	'
