# Mapping reads
# fastq paired end --> bam file 

# 1) Alignment (BWA)
XBWApath aln -t Xthread_num XGATKbundlePath/hg19/ucsc.hg19.fasta Xsample_path/Xread1 > Xworking_path/Xread1.sai
XBWApath aln -t Xthread_num XGATKbundlePath/hg19/ucsc.hg19.fasta Xsample_path/Xread2 > Xworking_path/Xread2.sai
XBWApath sampe -r 'Xread_group' XGATKbundlePath/hg19/ucsc.hg19.fasta Xworking_path/Xread1.sai Xworking_path/Xread2.sai  Xsample_path/Xread1 Xsample_path/Xread2  >  Xworking_path/Xsample_name.sam

# 2) SAM -> BAM and Sort BAM file (samtools)
XSamToolPath view -bt XGATKbundlePath/hg19/ucsc.hg19.fasta.fai Xworking_path/Xsample_name.sam | XSamToolPath sort - Xworking_path/Xsample_name.sort

# 3) Mark duplicates (picard)
java -XmxXmapMemory -XX:ParallelGCThreads=Xthread_num -jar XPicardPath/MarkDuplicates.jar INPUT=Xworking_path/Xsample_name.sort.bam OUTPUT=Xworking_path/Xsample_name.asd.bam METRICS_FILE=Xworking_path/Xsample_name.asd.bam.dupl AS=true VALIDATION_STRINGENCY=LENIENT

# 4) Generate BAM index (samtools)
XSamToolPath index Xworking_path/Xsample_name.asd.bam

# 5) Clean up unnecessary files
rm Xworking_path/Xread1.sai
rm Xworking_path/Xread1.sai
rm Xworking_path/Xsample_name.sam
rm Xworking_path/Xsample_name.sort.bam
