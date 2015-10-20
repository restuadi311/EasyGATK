# Check Sample Coverage (average depth) and decide minPruning value
# create sample_coverage.summary --> decide minPrune based on the average depth --> variant calling pipelines

# 1) Depth of Coverage 
java -XmxXBamMemory -jar XGATK_path \
   -T DepthOfCoverage \
   -R XGATKbundlePath/hg19/ucsc.hg19.fasta \
   -L XbedFile_path \
   -o Xworking_path/check_coverage_Xsample_name.txt \
   -I Xworking_path/Xsample_name.asdrr.bam

# 2) MinPruning decision + step 4 : variant calling pipeline
python haplotypeCaller_minpruneEstimate.py Xsample_name