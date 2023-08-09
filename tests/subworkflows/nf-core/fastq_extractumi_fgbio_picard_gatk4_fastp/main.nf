#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FASTQ_EXTRACTUMI_FGBIO_PICARD_GATK4_FASTP } from '../../../../subworkflows/nf-core/fastq_extractumi_fgbio_picard_gatk4_fastp/main.nf'


workflow test_fastq_extractumi_fgbio_picard_gatk4_fastp {
    // load test data
    def bashScriptFile = new File('install_data.sh')

    def processBuilder = new ProcessBuilder('bash', bashScriptFile.toString())
    processBuilder.redirectOutput(ProcessBuilder.Redirect.INHERIT)
    processBuilder.redirectError(ProcessBuilder.Redirect.INHERIT)

    def process = processBuilder.start()
    process.waitFor()

    // channels enable parralle: https://www.nextflow.io/docs/latest/faq.html?highlight=parallel
    fastq = [
    [[id:'gene1', single_end:false], [file('test_nucleo/fastq/seracare_0-5_R1_001ad.fastq.gz'), file('test_nucleo/fastq/seracare_0-5_R2_001ad.fastq.gz')]],
    [[id:'gene2', single_end:false], [file('test_nucleo/fastq/seracare_0-5_R1_001ae.fastq.gz'), file('test_nucleo/fastq/seracare_0-5_R2_001ae.fastq.gz')]]
    ]
    fastq = ch_fastq = Channel.fromList(fastq)
    FASTQ_EXTRACTUMI_FGBIO_PICARD_GATK4_FASTP ( fastq )
}
