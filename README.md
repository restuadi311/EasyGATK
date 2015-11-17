#EasyGATK version 1.1 (23OCT2015)

EasyGATK is a python based wrapper script designed to help researchers set-up and perform whole-exome sequence analyses using the GATK pipeline. 

There are several files in this package:

1. `EasyGATK_configuration.txt`: to set-up software path, input files, references, etc.
2. `EasyGATK_ver1.py`: the main script of EasyGATK
3. `functions.py`: include all basic function libraries
4. `haplotypeCaller_minpruneEstimate.py`: to automatically assign minPruning values based on sequencing depth

(in template folder)
5. `template1_mapping.sh`: an example of commands generated by EasyGATK for step 1 (see details in the `EasyGATK_configuration.txt` file)
6. `template2_Bam_PreProcessing.sh`: an example of commands generated by EasyGATK for step 2
7. `template3_checkCoverage.sh`: an example of commands generated by EasyGATK for step 3
8. `template4_HaplotypeCaller_HardFilter.sh`: an example of commands generated by EasyGATK for step 4 by using hard filtering
9. `template4_HaplotypeCaller_VQSR.sh`: an example of commands generated by EasyGATK for step 4 by using VQSR

`EasyGATK.py` is the main script of EasyGATK. It will call functions from `functions.py` to set-up the GATK pipeline based on information provided in `configuration.txt`. By default, `haplotypeCaller_minpruneEstimate.py` will read the depth of coverage result for each sample and then assign an optimal `minPruning` value for `HaplotypeCaller`.

##General instructions
1. Set paths and parameters in `EasyGATK_configuration.txt`
  * Most default values and examples have already been provided
  * Use the absolute path for software tools (e.g. `/usr/username/data/GenomeAnalysisTK-3.4-0/GenomeAnalysisTK.jar`)
  * Use the absolute path for working directory and input sample directory (e.g. `/usr/username/woking_dir/`)

2. run the script (type in shell: `python EasyGATK_ver1.py`)

3. EasyGATK will generate 4 shell script files (.sh)
  * `Step1_MappingReads_sample_name.sh`
  * `Step2_BAMpre-processing_sample_name.sh`
  * `Step3_CheckCoverage_sample_name.sh` (not created if `minprune_estimate = no`)
  * `Step4_VariantCalling_sample_name.sh` (note that the "Step4" file will be created after run the "Step3" script if `minprune_estimate = yes`)

4. Run the .sh file

Users may directly run these shell script files one by one on terminal using a computing node by making the `.sh` file executable (`chmod a+x /path/to/Step1_MappingReads_sample_name.sh`), and then running `./Step1_MappingReads_sample_name.sh`

Users may also submit the `.sh` commands using job submitting system such as `qsub`, or using computer array to parallel jobs.

The `minPruning` setting were optimized for Whole-Exome Sequencing data. The additional and expert settings could be modified from template files.

##Important features
1. Deciding on a `minPruning` value
If you do not know the depth of coverage of your samples, please use option “yes” on `minprune_estimate` in `EasyGATK_configuration.txt`. With `minprune_estimate = yes`, EasyGATK will ignore the default minPruning value in `EasyGATK_configuration.txt` and create `Step3_CheckCoverage_sample_name.sh`. The `Step4_ VariantCalling_sample_name.sh` will be created after Step3 is done.

If you know the depth of coverage or want to manually set the minPruning value, you can use `minprune_estimate = no` in `EasyGATK_configuration.txt` and manually assign a minPruning value. In this case the "Step3" script will not be created. Please proceed from "Step2" directly to "Step4".

##Requirements
EasyGATK v1.0 has been tested based on GATK v3.2.2, GATK bundle 2.5 hg19, Samtools v0.1.17, Picard v1.72, and BWA v0.6.2.

Minimum requirements:

1. To run EasyGATK.py:
  * Requires Python 2.6 or above
2. To run the whole BWA-GATK pipeline
  * All software tools (GATK3, samtools, Picard and BWA) are installed.
  * All referece files (GAKT bundle files) are downloaded.

Note that the GATK bundle file can be downloaded from the below location as addressed here http://gatkforums.broadinstitute.org/discussion/1215/how-can-i-access-the-gsa-public-ftp-server:
  location: ftp.broadinstitute.org
  username: gsapubftp-anonymous
  password: <blank>
