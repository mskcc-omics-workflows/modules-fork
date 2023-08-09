#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FASTQ_EXTRACTUMI_FGBIO_PICARD_GATK4_FASTP } from '../../../../subworkflows/nf-core/fastq_extractumi_fgbio_picard_gatk4_fastp/main.nf'
include { FASTQ_ALIGNSORT_BWA_PICARD } from '../../../../subworkflows/nf-core/fastq_alignsort_bwa_picard/main.nf'

workflow test_fastq_alignsort_bwa_picard {
    // load test data
    def bashScriptFile = new File('install_data.sh')

    def processBuilder = new ProcessBuilder('bash', bashScriptFile.toString())
    processBuilder.redirectOutput(ProcessBuilder.Redirect.INHERIT)
    processBuilder.redirectError(ProcessBuilder.Redirect.INHERIT)

    def process = processBuilder.start()
    process.waitFor()

    // run extract umi
    fastq = [
    [[id:'gene1', single_end:false], [file('test_nucleo/fastq/seracare_0-5_R1_001ad.fastq.gz'), file('test_nucleo/fastq/seracare_0-5_R2_001ad.fastq.gz')]],
    [[id:'gene2', single_end:false], [file('test_nucleo/fastq/seracare_0-5_R1_001ae.fastq.gz'), file('test_nucleo/fastq/seracare_0-5_R2_001ae.fastq.gz')]]
    ]
    fastq = ch_fastq = Channel.fromList(fastq)
    FASTQ_EXTRACTUMI_FGBIO_PICARD_GATK4_FASTP ( fastq )



    // channels enable parallel: https://www.nextflow.io/docs/latest/faq.html?highlight=parallel
    // test data
    fastqs = FASTQ_EXTRACTUMI_FGBIO_PICARD_GATK4_FASTP.out.fastq
    reference = [
        [id:'reference'],
        file('test_nucleo/reference/chr14_chr16.fasta')
    ]
    // workflow
    FASTQ_ALIGNSORT_BWA_PICARD ( fastqs, reference, 1)
}
