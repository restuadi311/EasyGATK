# detect minprune and run make haplotype caller pipeline

from functions import *
import sys

sample_name = sys.argv[1]

# load the coverage summary 
config = load_config_file("EasyGATK_configuration.txt")
work_dir = config.get('working_directory')
coverage_file = work_dir+'/'+'check_coverage_'+sample_name+'.txt.sample_summary'
summary = open(coverage_file)

# reading the file
depth = 0
for line in summary:
	if line.startswith('Total'):
		info = line.split()
		depth = float(info[2])

# decide minPrune value
if depth == 0:
	print "Something wrong with your check_coverage_pipelines. Please check again !"
else:
	if depth > 50 :
		minprune=4
	elif 30 <= depth < 50:
		minprune=3
	else :
		minprune = 2


minprune=str(minprune)

# create "step 4 : variant calling"
out4 = "Step4:VariantCalling_"+sample_name+'.sh'

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
	
print "Done"

