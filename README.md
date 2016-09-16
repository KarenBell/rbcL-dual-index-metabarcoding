# rbcL-dual-index-metabarcoding
This method uses the bioinformatics pipeline described in Sickel et al. (2015), with the modifications of Bell et al. (in prep).

# Dependencies
•	Meta-barcoding dual-indexing bioinformatics pipeline (https://github.com/molbiodiv/meta-barcoding-dual-indexing) and all dependencies described therein.

•	rbcL database trained for RDP and UTAX identifications (https://dx.doi.org/10.6084/m9.figshare.c.3466311) 

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

Download the RDP and UTAX trained databases for rbcL identification (https://dx.doi.org/10.6084/m9.figshare.c.3466311), and place them in the “myanalyses”. Unzip the files “rbcL_rdp_trained” and “rbcL_utax_trained”.

In the “myanalyses” directory, run the following command to classify and aggregate rbcL sequences for all samples:

    perl ../code/classify_reads_subsequent.pl --out results <path_to_reads>/*.fastq\
     --utax-db rbcL_utax_trained/rbcL_all_Jan2016.utax.udb\
     --utax-taxtree rbcL_utax_trained/rbcL_all_Jan2016.utax.tax\
     --rdp --rdp-jar <path_to_RDPTools>/classifier.jar\
     --rdp-train-propfile rbcL_rdp_trained/rbcL.properties

# Meta-barcoding Dual-Indexing rbcL only
Follow the instructions at https://github.com/molbiodiv/meta-barcoding-dual-indexing to clone their repository and install the dependencies.

Make a new directory inside the “meta-barcoding-dual-indexing” directory. Name it “myanalyses”.

Download the RDP and UTAX trained databases for rbcL identification (https://dx.doi.org/10.6084/m9.figshare.c.3466311), and place them in the “myanalyses”. Unzip the files “rbcL_rdp_trained” and “rbcL_utax_trained”.

Put all your fastq read files in an empty directory.

In the “myanalyses” directory, run the following command to join, filter, classify and aggregate rbcL sequences for all samples:

    perl ../code/classify_reads.pl --out results <path_to_reads>/*.fastq\
     --utax-db rbcL_utax_trained/rbcL_all_Jan2016.utax.udb\
     --utax-taxtree rbcL_utax_trained/rbcL_all_Jan2016.utax.tax\
     --rdp --rdp-jar <path_to_RDPTools>/classifier.jar\
     --rdp-train-propfile rbcL_rdp_trained/rbcL.properties


