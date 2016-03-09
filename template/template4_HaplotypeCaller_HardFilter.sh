# Variant Calling  
# Analysis ready BAM file --> VCF file (Hard filtered)--> high confidence SNPs 

#1)  HaplotypeCaller
java -XmxXCallMemory -jar XGATK_path -l INFO \
                                -T HaplotypeCaller \
                                -I Xworking_path/Xsample_name.asdrr.bam \
                                -R XGATKbundlePath/hg19/ucsc.hg19.fasta \
                                --dbsnp XGATKbundlePath/hg19/dbsnp_137.hg19.vcf \
                                --out Xworking_path/Xsample_name.asdrr.gvcf \
                                -stand_call_conf 30.0 \
                                -stand_emit_conf 10.0 \
                                -minPruning Xminprunning \
                                -pairHMM VECTOR_LOGLESS_CACHING \
                                -ERC GVCF \
                                --variant_index_type LINEAR --variant_index_parameter 128000 \
                                -L XbedFile_path

#2)  GenotypeGVCFs
java -XmxXCallMemory -jar XGATK_path -l INFO \
                            	-T GenotypeGVCFs \
                                -R XGATKbundlePath/hg19/ucsc.hg19.fasta \
                                --dbsnp XGATKbundlePath/hg19/dbsnp_137.hg19.vcf \
                                -V Xworking_path/Xsample_name.asdrr.gvcf \
                                -o Xworking_path/Xsample_name.asdrr.raw.vcf \
                                -L XbedFile_path

#3)  HardFiltering
java -XmxXCallMemory -jar XGATK_path -l INFO \
							-T SelectVariants \
							-R XGATKbundlePath/hg19/ucsc.hg19.fasta \
							-V Xworking_path/Xsample_name.asdrr.raw.vcf \
							-L XbedFile_path \
							-selectType SNP \
							-o Xworking_path/Xsample_name.asdrr.raw_snps.vcf 

java -XmxXCallMemory XGATK_path -l INFO \
							-T VariantFiltration \
							-R XGATKbundlePath/hg19/ucsc.hg19.fasta \
							-V Xworking_path/Xsample_name.asdrr.raw_snps.vcf  \
							--filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || HaplotypeScore > 13.0 || MappingQualityRankSum < -12.5 || ReadPosRankSum < -8.0" \
							--filterName "my_snp_filter1" \
							-o Xworking_path/Xsample_name.asdrr.filtered_snps.vcf 

