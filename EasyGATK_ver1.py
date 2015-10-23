### EasyGATK main() ###
### version 1.1		###


from functions import *
import re
import os


# load values from config file
config = load_config_file("EasyGATK_configuration.txt")

sample_name = config.get("sample_name")

out1 = "Step1_MappingReads_"+sample_name+'.sh'
out2 = "Step2_BAMpre-processing_"+sample_name+'.sh'
out3 = "Step3_CheckCoverage_"+sample_name+".sh"
out4 = "Step4_VariantCalling_"+sample_name+'.sh'

# load template folder
script_dir = os.path.dirname(__file__) 
rel_path = "template/"
abs_template_path = os.path.join(script_dir, rel_path)


# create "step 1 : mapping"
template1 = abs_template_path+'template1_mapping.sh'
make_mapping_pipeline(config, template1, out1)
print "Writing mapping pipelines"

# create "step 2 : BAM pre-processing"
template2 = abs_template_path+'template2_Bam_PreProcessing.sh'
make_bam_preProcessing_pipeline(config, template2, out2)
print "Writing pre-processing pipelines"


# check the need of minPrune estimation 
minPrune_estimate = config.get('minprune_estimate')

# create step 3 or step 4 depends on minprune_estimate setting
varCall = True

# create "step 3 : check coverage"
if minPrune_estimate == 'yes': 
	template3 = abs_template_path+'template3_checkCoverage.sh'
	make_check_coverage_pipeline(config, template3, out3)
	varCall = False

# create "step 4 : variant calling"
if varCall :
	minPrune = str(config.get('minpruning'))
	vqsr = config.get('VQSR')
	
	if vqsr == 'yes':
		template4 = abs_template_path+'template4_HaplotypeCaller_VQSR.sh'
		make_haplotype_HF_pipeline(config, template4, out4, minPrune)
		print "Writing variant calling pipelines"
	elif vqsr == 'no':
		template4 = abs_template_path+'template4_HaplotypeCaller_HardFilter.sh'
		make_haplotype_HF_pipeline(config, template4, out4, minPrune)
		print "Writing variant calling pipelines"
	else:
		print "Warning : VQSR option value is not correct (yes or no) don't use capitals"
	
	print "DONE"

else:
	print "please Check and run Step 4 : Variant Calling .sh file after step 3 finished"


