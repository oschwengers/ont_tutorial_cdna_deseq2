import os
import re
from snakemake.remote.HTTP import RemoteProvider as HTTPRemoteProvider

HTTP = HTTPRemoteProvider()

configfile: "config.yaml"

# characterise and/or prepare the specified reference genome
reference_genome = config["reference_genome"]
genome_annotation = config["genome_annotation"]

# remove leading https / http / ftp ...
reference_genome = re.sub("^[^:]+://","",reference_genome) 
genome_annotation = re.sub("^[^:]+://","",genome_annotation)

# extract samples from the configfile
Samples = []
for i in range(len(config["Samples"])):
  dataSlice = config["Samples"][i]
  conditionSamples = list(list(dataSlice.items())[0][1].items())
  for j in range(len(conditionSamples)):
    sequenceFile = conditionSamples[j][1]
    sequenceFile = re.sub("RawData/","",sequenceFile) # this should be abstracted
    #print(sequenceFile)
    Samples.append(sequenceFile)

# https://stackoverflow.com/questions/53379629/snakefile-and-wildcard-regex-for-output-file-naming

# Split the filenames into basename and extension
files = [filename.split('.', 1) for filename in Samples]
# Create a dictionary of mapping basename:extension
file_dict = {filename[0]: filename[1] if len(filename) == 2 else '' for filename in files}


ReferenceGenome = os.path.join("ReferenceData", os.path.basename(reference_genome))
ReferenceIndex = ReferenceGenome + ".mmi"
GenomeAnnotation = os.path.join("ReferenceData", os.path.basename(genome_annotation))

rule all:
  input:
    expand("Analysis/flagstat/{seqid}.txt", seqid=file_dict.keys()),
    ReferenceIndex,
    GenomeAnnotation

rule download_reference_genome:
  input:
    HTTP.remote(reference_genome, keep_local=True)
  output:
    ReferenceGenome
  run:
    shell("mv {input} {output}")


rule download_genome_annotation:
  input:
    HTTP.remote(genome_annotation, keep_local=True)
  output:
    GenomeAnnotation
  run:
    shell("mv {input} {output}")

rule minimap_ref_idx:
  input:
    ReferenceGenome
  output:
    ReferenceIndex
  shell:
    "minimap2 -k14 -w5 -d {output} {input}"


rule minimap:
  input:
    index=ReferenceIndex,
    fastq=lambda wc: "RawData/" + wc.seqid + "." + file_dict[wc.seqid]
  output:
    bam="Analysis/Minimap/{seqid}.bam"
  shell:
    "minimap2 -t 8 -ax splice -k14 --secondary=no {input.index} {input.fastq} | samtools view -Sb | samtools sort - -o {output.bam}"


rule flagstat:
  input:
    "Analysis/Minimap/{seqid}.bam"
  output:
    "Analysis/flagstat/{seqid}.txt"
  shell:
    "samtools flagstat {input} > {output}"


