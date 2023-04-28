#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { MSKCC_ARRIBA } from '../../../../subworkflows/nf-core/mskcc_arriba/main.nf'

workflow test_mskcc_arriba {

    input = [ 
        [ id:'test', single_end:false ], // meta map
        [   
            file(params.test_data['homo_sapiens']['illumina']['test_rnaseq_1_fastq_gz'], checkIfExists: true),
            file(params.test_data['homo_sapiens']['illumina']['test_rnaseq_2_fastq_gz'], checkIfExists: true) 
        ]
    ]
    fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)

    MSKCC_ARRIBA (
        input,
        [],
        fasta,
        gtf,
        [],
        [],
        [],
        [],
        []
    )
}
