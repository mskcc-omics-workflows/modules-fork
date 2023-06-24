## mergefastq

#### Description:

Merge Fastq files from two lanes to one

#### Usage:

Inputs:

- <Sample_Name>\_L001_R1_001.fastq.gz (usually) OR <Sample_Name>\_R2_001.fastq.gz (for fastq files without lane information)
- <Sample_Name>\_L002_R1_001.fastq.gz (usually) OR null (for fastq files without lane information)

Outputs:

- <Sample_Name>\_L000_R1_mrg.fastq.gz

#### Reference

```sh
zcat <Sample_Name>__L001_R1_001.fastq.gz <Sample_Name>_L002_R1_001.fastq.gz | gzip > <Sample_Name>_L000_R1_mrg.fastq.gz
```

### Dockerfile
```sh
FROM ubuntu:18.04
LABEL authors="Yu Hu" \
    description="Docker image containing MERGEFASTQ tool to merge raw fastq files"

# 'ps' command is needed by some nextflow executions to collect system stats
# Install procps and clean apt cache
RUN apt-get update \
    && apt-get install -y \
    procps \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Zcat and gzip cmds
RUN apt-get install gzip
RUN which zcat
RUN which gzip
```
