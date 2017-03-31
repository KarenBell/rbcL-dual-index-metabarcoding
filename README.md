# rbcL-dual-index-metabarcoding
This method uses the bioinformatics pipeline described in Sickel et al. (2015), with the modifications of Bell et al. (in prep).

# Dependencies
•	Meta-barcoding dual-indexing bioinformatics pipeline (https://github.com/molbiodiv/meta-barcoding-dual-indexing) and all dependencies described therein.

•	rbcL database trained for RDP and UTAX identifications (https://doi.org/10.6084/m9.figshare.c.3466311.v1) 

# Meta-barcoding Dual-Indexing multiplexed rbcL and ITS2
Follow the instructions at https://github.com/molbiodiv/meta-barcoding-dual-indexing to identify ITS2 sequences.

After completing this step you will have various files and directories in the directory “myanalyses” within the “meta-barcoding-dual-indexing” directory on your computer. You will need to keep the files in the directories “joined” and “filtered”. These directories contain the Illumina MiSeq sequence files that have the forward and reverse reads joined, and filtered for sequence quality. There is no need to repeat this step before identifying the rbcL sequences. Other files can be moved out of the “myanalysis” directory. This is recommended to avoid accidently rewriting any of these files.

Since you have already joined and filtered your sequence data, you can skip these steps of the analysis. Make a copy of the perl script “classify_reads.pl” and remove the lines:

    # Join with fastq-join
    my $cmd_fj = "$opt_fastq_join_bin $r1 $r2 -o $opt_out/joined/$base.%.fq\n";
    print_and_execute($cmd_fj);

    # Filter with usearch
    my $cmd_us = "$opt_usearch_bin -fastq_filter $opt_out/joined/$base.join.fq -fastq_truncqual $opt_fastq_truncqual -fastq_minlen 150 -fastqout $opt_out/filtered/$base.fq";
    print_and_execute($cmd_us);

Rename this version of the script “classify_reads_subsequent.pl”. This modified script is also available here on this repository.

Download the RDP and UTAX trained databases for rbcL identification (https://doi.org/10.6084/m9.figshare.c.3466311.v1), and place them in the “myanalyses”. Unzip the files “rbcL_rdp_trained” and “rbcL_utax_trained”.

In the “myanalyses” directory, run the following command to classify and aggregate rbcL sequences for all samples:

    perl ../code/classify_reads_subsequent.pl --out results <path_to_reads>/*.fastq\
     --utax-db rbcL_utax_trained/rbcL_all_Jan2016.utax.udb\
     --utax-taxtree rbcL_utax_trained/rbcL_all_Jan2016.utax.tax\
     --rdp --rdp-jar <path_to_RDPTools>/classifier.jar\
     --rdp-train-propfile rbcL_rdp_trained/rbcL.properties

# Meta-barcoding Dual-Indexing rbcL only
Follow the instructions at https://github.com/molbiodiv/meta-barcoding-dual-indexing to clone their repository and install the dependencies.

Make a new directory inside the “meta-barcoding-dual-indexing” directory. Name it “myanalyses”.

Download the RDP and UTAX trained databases for rbcL identification (https://doi.org/10.6084/m9.figshare.c.3466311.v1), and place them in the “myanalyses”. Unzip the files “rbcL_rdp_trained” and “rbcL_utax_trained”.

Put all your fastq read files in an empty directory.

In the “myanalyses” directory, run the following command to join, filter, classify and aggregate rbcL sequences for all samples:

    perl ../code/classify_reads.pl --out results <path_to_reads>/*.fastq\
     --utax-db rbcL_utax_trained/rbcL_all_Jan2016.utax.udb\
     --utax-taxtree rbcL_utax_trained/rbcL_all_Jan2016.utax.tax\
     --rdp --rdp-jar <path_to_RDPTools>/classifier.jar\
     --rdp-train-propfile rbcL_rdp_trained/rbcL.properties

# Building the reference library
We built our rbcL reference library using NCBI sequences and Geneious. This same procedure can be followed for any DNA barcode marker, and we have provided our R scripts for this purpose. To follow our procedure, downloaded all available sequences (which may include various other flanking sequences, or entire chloroplast genomes) for the marker of interest as a FASTA file. Open these sequences in Geneious (http://www.geneious.com/). Downloaded full details of each GenBank record, including the accession number and GI number, from Geneious as a comma-separated value (.csv) file, before you go any further, because some functions in Geneious will strip this data. Extract the sequences of the gene of interest from these records, using the “extract annotations” tool in Geneious. Filter these extractions to remove any sequences of less than 100 bp. Export sequences as a single FASTA file from Geneious, with the “LOCUS” and “DEFINITION” fields from NCBI as the sequence header. Use the R scripts ‘genbank-accession-matching_APPS.R’ and the database of accession numbers and GI numbers from NCBI (ftp://ftp.ncbi.nih.gov/gene/DATA/gene2accession.gz) to search the “LOCUS” field information from the sequence headers of the FASTA file to find the GI number. Use the R script ‘rbcL-matcherII.R’ to output a FASTA file with the GenBank Identification (GI) number, accession number, and species for each sequence. Now that you have a FASTA file with GI numbers, you can go ahead and train the databases for RDP and UTAX, following the instructions on https://github.com/molbiodiv/meta-barcoding-dual-indexing.

