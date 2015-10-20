### EasyGATK main() ###

from functions import *
import re

# load values from config file
config = load_config_file("configuration.txt")

sample_name = config.get("sample_name")

out1 = "Step1_MappingReads_"+sample_name+'.sh'
out2 = "Step2_BAMpre-processing_"+sample_name+'.sh'
out3 = "Step3_CheckCoverage_"+sample_name+".sh"
out4 = "Step4_VariantCalling_"+sample_name+'.sh'


# create "step 1 : mapping pipelines"
make_mapping_pipeline(config, 'template1_mapping.sh', out1)
print "Writing mapping pipelines"

make_bam_preProcessing_pipeline(config, 'template2_Bam_PreProcessing.sh', out2)
print "Writing pre-processing pipelines"


# check the need of minPrune estimation 
minPrune_estimate = config.get('minprune_estimate')

varCall = True
if minPrune_estimate == 'yes': 
	make_check_coverage_pipeline(config,'template3_checkCoverage.sh', out3)
	varCall = False

if varCall :
	minPrune = str(config.get('minpruning'))
	make_haplotype_HF_pipeline(config, 'template4_HaplotypeCaller_HardFilter.sh', out4, minPrune)
	print "Writing haplotypecaller-hardFilter pipelines"
	print "DONE"
else:
	print "please Check and run Step 4 : Variant Calling .sh file after step 3 finished"


