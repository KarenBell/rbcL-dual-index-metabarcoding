# genbank matching

library(data.table)
library(fastmatch)

# import rbcL table that needs matches:
rbcl = fread("rbcl.csv", header = F)

# create blank column for matches to go into (filled with NAs to start)
rbcl$ncbi = rep(NA, nrow(rbcl))

# 'for' loop imports 25 million rows of ncbi database at a time, then matches them against the rbcl data
# 'i in 1:29' because there are 707 million rows in the ncbi database, and 707/29 = 28.28
# checked 'fread' function and no problem if the nrow argument exceeds the number of rows in the database

# set number of rows to import at a time
# I clocked several and importing 25M rows typically came in at just over a minute, and I think is about 0.5 GB
# not a huge slowdown in terms of other processes on the computer
j = 25000000

# 'for' loop:
for(i in 1:29) { 
	# data import
	ncbi = fread("GbAccList.0306.2016.csv", skip = (i - 1)*j, nrow = j, drop = 2, header = F)
	
	# match values from imported ncbi data to our rbcL data:
	matcher = fmatch(rbcl$V1, ncbi$V1)
	
	# can't write over the data in ncbi each time; only want to write over matches (not NAs)
	# create 'values' dataframe from 'matcher' with indexes in first column and values in second column
	values = data.frame(indices = which(is.na(matcher)==F), vals = ncbi$V3[matcher[which(is.na(matcher)==F)]])
	
	# append only the matches to the table
	rbcl$ncbi[values$indices] = values$vals
}

# save result into a .csv file:
write.csv(rbcl, file = "rbcl-identifiers.csv")


# =====================================
# =====================================
# double-check that values match:
rbcl[values$indices,]
	         # V1      ncbi
	# 1: EDU80695 189362276
	# 2: EDU80695 189362276
ncbi[matcher[which(is.na(matcher)==F)]]
	         # V1 V2        V3
	# 1: EDU80695  1 189362276
	# 2: EDU80695  1 189362276
# perfect!
# =====================================
