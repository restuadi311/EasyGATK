Easy GATK version 1

This is a python based script to build GATK pipelines according to the GATK best practices 
for analyzing the Next Generation Sequencing data. 

There are several files in this package:

	1.	configuration.txt : where you put all of the settings
	2.	EasyGATK_ver1.py : the main script to build the pipelines
	3.	functions.py : All of the basic function library
	4.	haplotypeCaller_minpruneEstimate.py : to decide minPruning value
	5.	template1_mapping.sh : template for mapping pipelines
	6.	template2_Bam_PreProcessing.sh : template for pre-processing pipelines
	7.	template3 _checkCoverage.sh : template for coverage (average depth) test
	8.	template4_HaplotypeCaller_HardFilter.sh : template for variant calling

(Please put all these 8 files together in one folder)

The basic functionalities in these scripts are making a series of command for GATK best practices. 
This version was optimized based on GATK ver.3.2.2, GATK bundle ver2.5, 
hg19 human genome reference, Samtools ver.0.1.17, Picard ver.1.72, and BWA ver.0.6.2.

Minimum Requirement:
1.	To run EasyGATK.py :
	-	Python 2.6 or above
2.	To run the whole pipelines
	-	All listed software above with their minimum requirements


The EasyGATK.py is the main interface. This script will call function from functions.py 
in order to operate and design the pipeline by modifying the standard templates based on 
the input from configuration.txt. While haplotypeCaller_minpruneEstimate.py read the 
coverage of the samples, decide minPruning value, and create the variant calling pipeline 
(based on coverage and minPruning value).


General Instruction:

1.	Set path and parameters in configuration.txt :
	-	Most of default value already provided
	-	Use the absolute path and software name for software path
		Example : /usr/username/data/GATK/gatk.jar
	-	Use the absolute path for working directory and sample directory
		Example : /usr/username/woking_dir/

2.	run the script :
	type in shell : $ python EasyGATK_ver1.py

3.	There will be 4 files produced (4 shell script .sh files):
	-	Step1_MappingReads_sample_name.sh
	-	Step2_BAMpre-processing_sample_name.sh
	-	Step3_CheckCoverage_sample_name.sh (not created if minprune_estimate = no)
	-	Step4_VariantCalling_sample_name.sh (created after Step3 done if minprune_estimate = yes)

4.	run the .sh file :
	-	if you run it on terminal (non-cluster):
		-	make the .sh file executable :  $chmod +x /path/to/mapping.sh
		-	and then : $ ./mapping.sh

	-	if you run it on cluster’s terminal:
		-	you can just directly submit the .sh file


The minPruning setting were optimized for Whole-Exome Sequencing data.  
The additional and expert settings could be modified from template files.

Important features:
1.	To decide minPruning value:
	-	 if you don not know the depth of coverage of your samples, use option “yes” on 
		minprune_estimate in configuration.txt. This will neglect the default values on 
		configuration files and create the Step3_CheckCoverage_sample_name.sh. 
		The Step4_ VariantCalling_sample_name.sh will be created after Step3 done.

	-	if you know the depth of coverage or already know which minPruning value to use, 
		you can choose “no” on minprune_estimate in configuration.txt and decide the 
		minPruning value on minPruning parameter space. In this case Step3 would not created, 
		please proceed directly to Step4.


