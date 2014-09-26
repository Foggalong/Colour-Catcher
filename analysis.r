#!/usr/bin/R

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

# Creates output PDF
pdf("output.pdf", width=6, height=10)

# Gets Data From File
event_file = read.csv(file="clrs.csv", header=F)

# Preparing for pallets
par()              # view current settings
opar <- par()      # make a copy of current settings
attach(mtcars)
par(pin=c(5, 0.5), mfrow=c(3,1))

# Checks if popular pallet needed
if ( length(event_file$V2) > 30 ) {
	# Top 8 pallet
	tmplist = c(1, 1, 1 ,1 ,1 ,1, 1, 1)
	popular = c()
	for (i in 1:8)
		popular[i] <- as.character(event_file$V2[i])
	popular
	# Generates Bar Plot
	barplot(tmplist, main="Popular Pallet",
		col=popular, border=F)
}


# Shows Total Pallet
# code here

# Restore pre-pallet settings
par(opar) 

# Shoes Proportional Pallet
# code here

# Generates Pie Chart
pie(event_file$V1, main="Pie Chart", labels="",
	col=as.character(event_file$V2), border=F)

# Generates Bar Plot
barplot(event_file$V1, main="Bar Plot", xlab="",
	col=as.character(event_file$V2), border=F)


