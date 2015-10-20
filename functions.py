### EASY GATK Functions Collections ###

import re
def load_config_file(config_name):
	""" load config values from config file"""
	
	# open the config file
	config = open(config_name)

	# config variable list :
	config_var = [
	'BWA_path',	'GATK_path', 'samtools_path', 'picard_path',
	'hg19_path', 'sample_name', 'sample_directory', 'working_directory',
	'read1', 'read2', 'read_group', 'mapping_memory', 'thread_num', 'bam_memory',
	'GATK_bundle', 'call_memory', 'minprunning', 'bed_file_path', 'minprune_estimate']

	# create dictionary to contain config values
	settings_dict = {}

	# insert the config values to dictionary
	for line in config:
		info = line.split()
		# print info
		if len(info) > 1:
			if info[0] in config_var:
				settings_dict[info[0]]=info[-1]

	return settings_dict


def make_mapping_pipeline(settings_dict, template, file_out_name):
	"""Making mapping pipelines for GATK 3"""
	#load settings
	work_dir = settings_dict.get('working_directory')
	sample_dir = settings_dict.get('sample_directory')

	sample_nm = settings_dict.get('sample_name')
	reads1 = settings_dict.get('read1')
	reads2 = settings_dict.get('read2')
	read_gr = settings_dict.get('read_group')
	GATKbun = settings_dict.get('GATK_bundle')
	mapMemory = settings_dict.get('mapping_memory')
	thread = settings_dict.get('thread_num')

	BWA = settings_dict.get('BWA_path')
	SAM = settings_dict.get('samtools_path')
	PIC = settings_dict.get('picard_path')

	#load template
	temp = open(template)
	file_out = open(file_out_name, 'w')

	#replace values in template
	for lines in temp:
		lines = re.sub("Xsample_path", sample_dir,lines)
		lines = re.sub("Xworking_path", work_dir,lines)
		lines = re.sub("Xsample_name", sample_nm, lines)
		lines = re.sub("Xread1",reads1 ,lines)
		lines = re.sub("Xread2",reads2 ,lines)
		lines = re.sub("XBWApath", BWA,lines)
		lines = re.sub("Xread_group",read_gr ,lines)
		lines = re.sub("XGATKbundlePath",GATKbun ,lines)
		lines = re.sub("XSamToolPath", SAM ,lines)
		lines = re.sub("XPicardPath", PIC ,lines)
		lines = re.sub("XmapMemory", mapMemory,lines )
		lines = re.sub("Xthread_num", thread,lines)
		#print lines
		file_out.write(lines)		
	#return file_out

def make_bam_preProcessing_pipeline(settings_dict, template, file_out_name):
	"""Making pre-processing pipelines for GATK 3"""
	#load settings
	work_dir = settings_dict.get('working_directory')
	GATKbun = settings_dict.get('GATK_bundle')
	sample_nm = settings_dict.get('sample_name')

	SAM = settings_dict.get('samtools_path')
	GAT = settings_dict.get('GATK_path')
	BamMem = settings_dict.get('bam_memory')

	#load template
	temp = open(template)
	file_out = open(file_out_name, 'w')

	#replace values in template
	for lines in temp:
		lines = re.sub("Xworking_path", work_dir,lines)
		lines = re.sub("XGATKbundlePath",GATKbun ,lines)
		lines = re.sub("Xsample_name", sample_nm, lines)
		lines = re.sub("XSamToolPath", SAM ,lines)
		lines = re.sub("XGATK_path", GAT ,lines)
		lines = re.sub("XBamMemory", BamMem ,lines)

		file_out.write(lines)
	#return file_out

def make_check_coverage_pipeline(settings_dict, template, file_out_name):
	work_dir = settings_dict.get('working_directory')
	GATKbun = settings_dict.get('GATK_bundle')
	sample_nm = settings_dict.get('sample_name')
	bed = settings_dict.get('bed_file_path')
	BamMem = settings_dict.get('bam_memory')

	
	GAT = settings_dict.get('GATK_path')
	callMem = settings_dict.get('call_memory')

	#load template
	temp = open(template)
	file_out = open(file_out_name, 'w')

	#replace values in template
	for lines in temp:
		lines = re.sub("Xworking_path", work_dir,lines)
		lines = re.sub("XGATKbundlePath",GATKbun ,lines)
		lines = re.sub("Xsample_name", sample_nm, lines)
		lines = re.sub("XGATK_path", GAT ,lines)
		lines = re.sub("XBamMemory", BamMem ,lines)
		lines = re.sub("XbedFile_path", bed, lines)
		file_out.write(lines)

def make_haplotype_HF_pipeline(settings_dict, template, file_out_name, minPrune):
	"""Making haplotypecaller-hardFilter pipelines for GATK 3"""
	#load settings
	work_dir = settings_dict.get('working_directory')
	GATKbun = settings_dict.get('GATK_bundle')
	sample_nm = settings_dict.get('sample_name')
	bed = settings_dict.get('bed_file_path')
	minPrune = str(settings_dict.get('minprunning'))

	
	GAT = settings_dict.get('GATK_path')
	callMem = settings_dict.get('call_memory')

	#load template
	temp = open(template)
	file_out = open(file_out_name, 'w')

	#replace values in template
	for lines in temp:
		lines = re.sub("Xworking_path", work_dir,lines)
		lines = re.sub("XGATKbundlePath",GATKbun ,lines)
		lines = re.sub("Xsample_name", sample_nm, lines)
		lines = re.sub("XGATK_path", GAT ,lines)
		lines = re.sub("XCallMemory", callMem ,lines)
		lines = re.sub("XbedFile_path", bed, lines)
		lines = re.sub("Xminprunning", minPrune, lines)
		file_out.write(lines)


