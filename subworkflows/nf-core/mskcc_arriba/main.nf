include { ARRIBA                        } from '../../../modules/nf-core/arriba/main'
include { STAR_GENOMEGENERATE           } from '../../../modules/nf-core/star/genomegenerate/main'
include { STAR_ALIGN as STAR_FOR_ARRIBA } from '../../../modules/nf-core/star/align/main'

workflow MSKCC_ARRIBA {

    take:
    reads
    star_idx // optional
    fasta
    gtf
    blacklist // optional
    known_fusions // optional
    structural_variants // optional
    tags // optional
    protein_domains // optional

    main:

    ch_versions = Channel.empty()

    if (!star_idx){
        STAR_GENOMEGENERATE(fasta,gtf)
        ch_versions = ch_versions.mix(STAR_GENOMEGENERATE.out.versions.first())
        star_idx = STAR_GENOMEGENERATE.out.index
    }

    STAR_FOR_ARRIBA(
        reads,
        star_idx,
        gtf,
        false,
        false,
        false
    )
    ch_versions = ch_versions.mix(STAR_FOR_ARRIBA.out.versions.first())

    ARRIBA(
        STAR_FOR_ARRIBA.out.bam,
        fasta,
        gtf,
        blacklist,
        known_fusions,
        structural_variants,
        tags,
        protein_domains
    )
    ch_versions = ch_versions.mix(ARRIBA.out.versions.first())

    emit:
    star_idx     = star_idx
    bam          = STAR_FOR_ARRIBA.out.bam
    fusions      = ARRIBA.out.fusions
    fusions_fail = ARRIBA.out.fusions_fail
    versions     = ch_versions 
}

