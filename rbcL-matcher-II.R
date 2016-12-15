# rbcL-matcher-II

# match "rbcL_Genbank_details_all.csv" with FASTA data "rbcL_all.fasta.csv"
# use the "name" column in the former
# in the FASTA data it's the first bit of text between ">" and "_" (or "-"?) [pulled this out in the prevoius R file]
# the latter might be encoded in "rbcl.csv"

# in addition, the "name" of each sequence is unique, so remove redundant sequences with the same name 

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# import & format FASTA data:
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# read in FASTA file:
all = read.csv("rbcL_all.fasta.csv", header = F)     

# number the rows, so that we can put the headers (odd rows) and sequence data (even rows) in two columns:
all$rows = 1:dim(all)[1]
evens = all[which(all$rows %% 2 ==0),]  
headers = all[which(all$rows %% 2 !=0),]

library(reshape2)
 # sorts header data into two columns (accession # in the new "header" column:)
headers = colsplit(headers$V1, "_-_", c("header", "other"))

# makes data.frame of headers and other data
all = data.frame(cbind(headers, evens))      

# get rid of extraneous info
all = all[,c(1,3)]

# get rid of ">" character in accession #
all$header = substr(all$header,2,nchar(all$header))

# rename sequence info column in 'all'
names(all)[2] = "FASTA"

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# import details file & match to FASTA
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# import accession-to-gi database:
id <- read.csv("rbcL_Genbank_details_all.csv", header=T)

# match names in FASTA file with names in details file:
library(fastmatch)
matching = fmatch(id$Name, all$header)

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# append genetic data to details file, format for output
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# append genetic data ('FASTA' column) onto "details" file ('id')
id$FASTA = all$FASTA[matching]

# create column of ">" symbols to append back on... 
id$gr = rep(">",dim(id)[1])

# append them
id$head = paste(id$gr, id$GID, sep = "")

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# get rid of duplicate rows (with the same entry in the "Name" column)
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# check how many rows are present, to see how many duplicates later:
nrow(id)
# 93065

library(data.table)
# remove duplicates:
id2 = unique(id, by = "Name")

nrow(id2)
# 93058--so only 7 duplicate names in the bunch

which(duplicated(id2, by = "Name")==T)
# integer(0) # it worked

# create file with just new gi header and sequence data
output = id2[,c(8,6)]

# save as a .csv file
write.csv(output, "rbcL_FASTA_GID.csv")

# complete.