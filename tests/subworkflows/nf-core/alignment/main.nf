#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { ALIGNMENT } from '../../../../subworkflows/nf-core/alignment/main.nf'

workflow test_alignment {


    // channels enable parralle: https://www.nextflow.io/docs/latest/faq.html?highlight=parallel
    // test data
    fastqs = [
    [[id:'gene', single_end:false], [params.test_data_msk['uncollapsed_bam_generation']['merged_fastq']['merged_1'], params.test_data_msk['uncollapsed_bam_generation']['merged_fastq']['merged_2']]]
    ]
    reference = [
        [id:'reference'],
        file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)
    ]

    fastqs = ch_fastq = Channel.fromList(fastqs)

    // workflow
    ALIGNMENT ( fastqs, reference, 1)
}
