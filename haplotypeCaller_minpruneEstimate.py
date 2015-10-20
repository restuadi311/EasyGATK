# detect minprune and run make haplotype caller pipeline

from functions import *
import sys

sample_name = sys.argv[1]

coverage_file = 'check_coverage_'+sample_name+'.txt.sample_summary'

summary = open(coverage_file)

depth = 0
for line in summary:
	if line.startswith('Total'):
		info = line.split()
		depth = float(info[2])

if depth == 0:
	print "Something wrong with your check_coverage_pipelines. Please check again"
else:
	if depth > 50 :
		minprune=4
	elif 30 <= depth < 50:
		minprune=3
	else :
		minprune = 2

minprune=str(minprune)
out4 = "Step4:VariantCalling_"+sample_name+'.sh'

config = load_config_file("configuration.txt")

make_haplotype_HF_pipeline(config, 'template4_HaplotypeCaller_HardFilter.sh', out4, minprune)
print "Writing haplotypecaller-hardFilter pipelines"

