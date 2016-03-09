# Variant Calling  
# Analysis ready BAM file --> VCF file (VQSR)--> high confidence SNPs 

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
			-V Xgvcf_path \
			-o Xworking_path/Xsample_name.raw.vcf \
			-L XbedFile_path

#3)  Variant Quality Score Recalibrartion
java -XmxXCallMemory -jar XGATK_path -l INFO \
			-T SelectVariants \
			-R XGATKbundlePath/hg19/ucsc.hg19.fasta \
			-V Xworking_path/Xsample_name.raw.vcf \
			-L XbedFile_path \
			-selectType SNP \
			-o Xworking_path/Xsample_name.SNP.raw.vcf 

java -XmxXCallMemory -jar XGATK_path  \
        	-T VariantRecalibrator \
            -R XGATKbundlePath/hg19/ucsc.hg19.fasta  \
            -input Xworking_path/Xsample_name.SNP.raw.vcf \
            -resource:hapmap,known=false,training=true,truth=true,prior=15.0 XGATKbundlePath/hg19/hapmap_3.3.hg19.vcf \
            -resource:omni,known=false,training=true,truth=true,prior=12.0 XGATKbundlePath/hg19/1000G_omni2.5.hg19.vcf \
            -resource:1000G,known=false,training=true,truth=false,prior=10.0 XGATKbundlePath/hg19/1000G_phase1.snps.high_confidence.hg19.vcf \
            -resource:dbsnp,known=true,training=false,truth=false,prior=2.0 XGATKbundlePath/hg19/dbsnp_137.hg19.vcf \
            -an QD -an MQRankSum -an ReadPosRankSum -an FS -an InbreedingCoeff \
            -mode SNP \
            -tranche 100.0 -tranche 99.9 -tranche 99.5 -tranche 99.0 -tranche 90.0 \
            -nt 4 \
            -recalFile Xworking_path/Xsample_name.SNP.recal  \
            -tranchesFile Xworking_path/Xsample_name.SNP.tranches  \
            -rscriptFile Xworking_path/Xsample_name.SNP.plots.R

java -XmxXCallMemory -jar XGATK_path \
            -T ApplyRecalibration \
            -R XGATKbundlePath/hg19/ucsc.hg19.fasta  \
            -input Xworking_path/Xsample_name.SNP.raw.vcf  \
            --ts_filter_level 99.5 \
            -recalFile Xworking_path/Xsample_name.SNP.recal \
            -tranchesFile Xworking_path/Xsample_name.SNP.tranches \
            -mode SNP \
            -o Xworking_path/Xsample_name.VQSR.SNP.vcf
