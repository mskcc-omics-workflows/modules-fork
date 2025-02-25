process ATLASGENEANNOTATIONMANIPULATION_GTF2FEATUREANNOTATION {
    tag "${meta.id}"
    label 'process_single'

    conda "bioconda::atlas-gene-annotation-manipulation=1.1.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/atlas-gene-annotation-manipulation%3A1.1.0--hdfd78af_0':
        'biocontainers/atlas-gene-annotation-manipulation:1.1.0--hdfd78af_0' }"

    input:
    tuple val(meta), path(gtf)
    tuple val(meta2), path(fasta)

    output:
    tuple val(meta), path("*.anno.tsv")                 , emit: feature_annotation
    tuple val(meta), path("*.fa.gz")                    , emit: filtered_cdna, optional: true
    path("versions.yml")                                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: meta.id
    def reference_cdna = fasta ? "--parse-cdnas $fasta" : ""

    """
    gtf2featureAnnotation.R \\
        --gtf-file $gtf \\
        --output-file ${prefix}.anno.tsv \\
        $reference_cdna \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        r-base: \$(echo \$(R --version 2>&1) | sed 's/^.*R version //; s/ .*\$//')
        atlas-gene-annotation-manipulation: 1.1.0
    END_VERSIONS
    """
}
