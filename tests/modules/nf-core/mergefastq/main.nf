#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { MERGEFASTQ } from '../../../../modules/nf-core/mergefastq/main.nf'

//ch_test_data = Channel.fromFilePairs('Sample*_L00{1,2}_R1_001.fastq.gz')
//    .flatten()
//    .toList()
//    .set { ch_pair_data }

// Sample*_R2_001.fastq.gz
//ch_test_data = Channel.fromPath('Sample*_L00{1,2}_R1_001.fastq.gz', checkIfExists:true)
ch_test_data = Channel.fromPath([params.test_data_msk['rawfastq']['fastq_1'], params.test_data_msk['rawfastq']['fastq_2']], checkIfExists:true)
    .toList()
    .map { fastq -> 
        def fastq_list = fastq.size == 2 ? fastq : fastq + [file("null")] // For single fastq file
        fastq_list }
    .flatten()
    .toList()
    .set{ ch_pair_data }
meta = [ id:'test', sample_name:'', read:'' ] // meta map

workflow test_mergefastq {
    
    ch_pair_data
        .map { fastq_1, fastq_2 ->
                meta.read = fastq_1.name.split('_')[-2].replace("R", "") // get read name
                meta.sample_name = fastq_1.name.split('_')[0]  // get sample name
                [ meta, fastq_1, fastq_2 ] }
        .set { input }

    MERGEFASTQ ( input )
}

//workflow {
//    test_mergefastq()
//}
//nextflow run main.nf -process.echo -profile docker 
