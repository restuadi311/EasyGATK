# Pre-processing BAM file
# raw BAM file --> analysis ready BAM file 

# 1) Indel Realignment
java -XmxXBamMemory -jar XGATK_path \
                        -T RealignerTargetCreator \
                        -l INFO   \
                        -I Xworking_path/Xsample_name.asd.bam \
                        -R XGATKbundlePath/hg19/ucsc.hg19.fasta \
                        -o Xworking_path/Xsample_name.asd.bam.intervals \
                        -known XGATKbundlePath/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf \
                        -known XGATKbundlePath/hg19/1000G_phase1.indels.hg19.vcf

java -XmxXBamMemory -jar XGATK_path \
                        -T IndelRealigner \
                        -l INFO  \
                        -I Xworking_path/Xsample_name.asd.bam \
                        -R XGATKbundlePath/hg19/ucsc.hg19.fasta \
                        -targetIntervals Xworking_path/Xsample_name.asd.bam.intervals \
                        --out Xworking_path/Xsample_name.asd.bam.real.bam \
                        -known XGATKbundlePath/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf \
                        -known XGATKbundlePath/hg19/1000G_phase1.indels.hg19.vcf

XSamToolPath index Xworking_path/Xsample_name.asd.bam.real.bam

# 2) Base Quality Score Recalibration
java -XmxXBamMemory -jar XGATK_path \
                        -T BaseRecalibrator \
                        -nct 6 \
                        -R XGATKbundlePath/hg19/ucsc.hg19.fasta \
                        -l INFO   \
                        -knownSites XGATKbundlePath/hg19/dbsnp_137.hg19.vcf \
                        -knownSites XGATKbundlePath/hg19/Mills_and_1000G_gold_standard.indels.hg19.vcf \
                        -knownSites XGATKbundlePath/hg19/1000G_phase1.indels.hg19.vcf \
                        -I Xworking_path/Xsample_name.asd.bam.real.bam \
                        -o Xworking_path/Xsample_name.asd.bam.BaseRecalibrator.grp

java -XmxXBamMemory -jar XGATK_path \
                        -T PrintReads \
                        -R /clusterdata/hiseq_apps/resources/freeze001/GATK_Resource_Bundle/bundle2.5/hg19/ucsc.hg19.fasta \
                        -l INFO   \
                        -I Xworking_path/Xsample_name.asd.bam.real.bam \
                        -BQSR Xworking_path/Xsample_name.asd.bam.BaseRecalibrator.grp \
                        -o Xworking_path/Xsample_name.asd.bam.real.recal.bam

XSamToolPath sort Xworking_path/Xsample_name.asd.bam.real.recal.bam Xworking_path/Xsample_name.asdrr.bam
XSamToolPath index Xworking_path/Xsample_name.asdrr.bam

# 3) Clean up unnecessary files
rm Xworking_path/Xsample_name.asd.bam.intervals
rm Xworking_path/Xsample_name.asd.bam.real.bam
rm Xworking_path/Xsample_name.asd.bam.real.bam.bai
rm Xworking_path/Xsample_name.asd.bam.BaseRecalibrator.grp
rm Xworking_path/Xsample_name.asd.bam.real.recal.bam