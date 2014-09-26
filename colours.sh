#!/bin/bash

# This is a quick script which extracts all the colour hex-codes out of
# a file or directory structure, runs some basic analysis on them, and
# then generates some simple representations based on frequency.
# Copyright (C) 2014  Joshua Fogg

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# Handle arguments
if [ -z "$1" ]; then
	# If none, use current directory
	1="."
elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
	# Display help menu
	echo -e \
		"Colour Catcher v0.1 (C) 2014  Joshua Fogg\n" \
		"\r\n" \
		"\rThis is a quick script which extracts\n" \
		"\rall the colour hex-codes used in a file\n" \
		"\ror folder. Then, some optional indepth\n" \
		"\ranalysis is done.\n" \
		"\r\n" \
		"\rTo run execute './colour.sh [FILE/DIR]'\n" \
		"\rwhere [FILE/DIR] is the file or directory\n" \
		"\ryou wish to analyse. If no argument is\n" \
		"\rgiven then the current directory will be\n" \
		"\rused by default."
	sleep 3
	exit 0
else
	# Checks flag exists as file  or directory
	if [ -d "$1" ] || [ -f "$1" ]; then
		: # pass
	else
		echo -e \
			"The selected arg does not exist as either\n" \
			"\ra file or a directory. Please check your\n" \
			"\rinput and then try again. For help, run\n" \
			"\r'./colour.sh --help' to see documentation."
		sleep 3
		exit 1
	fi
fi

# Fetches hex-codes from files & fixes formatting
grep -r -h -o "#[a-fA-F0-9]\{6\}" "$1" | tr -d "#" > output.clrs
tr "[:lower:]" "[:upper:]" < output.clrs > clrs.tmp

# Checks whether colours were found
if grep -q "[a-fA-F0-9]\{6\}" clrs.tmp; then
	: # pass
else
	echo "The argument doesn't contain any colours!"
	rm clrs.tmp output.clrs
	exit 0
fi

# Sorts codes by frequency
sort clrs.tmp | uniq -c | sort -rn > output.clrs && rm clrs.tmp

# Optional Analysis
while true; do
	read -p "Do you wish to do further analysis? " answer
	case $answer in
		[Yy]* ) break;;
		[Nn]* ) echo "The analysis is found in output.clrs"; exit;;
		* ) echo "Please answer [Y/y]es or [N/n]o.";;
	esac
done

# Verifies if dependencies is installed
depends=(R)
for package in "${depends[@]}"; do
	if type "$package" >> /dev/null 2>&1; then
		: # pass
	else
		echo -e \
			"Further analysis requires '$package' to be\n" \
			"\rinstalled. Please install it and then run\n" \
			"\rthis script again."
		sleep 3
		exit 1
	fi
done

# Preparing data for analysis
cp output.clrs clrs.csv
sed -i -e "s/^[ \t]*//" clrs.csv
sed -i "s/ /,#/g" clrs.csv

# Running analysis via R
R -q --no-save < analysis.r # >> /dev/null 2>&1
# rm clrs.csv

# End
echo -e \
	"The basic analysis is found in output.clrs\n" \
	"\rand more detailed graphical analysis can\n" \
	"\rbe found in in Rplots.pdf"
exit 0