process CDHIT_CDHITEST {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::cd-hit=4.8.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/cd-hit%3A4.8.1--h5b5514e_7':
        'biocontainers/cd-hit:4.8.1--h5b5514e_7' }"

    input:
    tuple val(meta), path(sequences)

    output:
    tuple val(meta), path("*.{fa,fq}")    ,emit: fasta
    tuple val(meta), path("*.clstr")      ,emit: clusters
    path "versions.yml"                   ,emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def suffix = task.ext.suffix ?: "${sequences}" ==~ /(.*f[astn]*a(.gz)?$)/ ? "fa" : "fq"

    def avail_mem = 3072
    if (!task.memory) {
        log.info '[cd-hit-est] Available memory not known - defaulting to 3GB. Specify process memory requirements to change this.'
    } else {
        avail_mem = (task.memory.mega*0.8).intValue()
    }
    """
    cd-hit-est \\
        $args \\
        -i ${sequences} \\
        -o ${meta.id}.${suffix} \\
        -M $avail_mem \\
        -T $task.cpus

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cdhit: \$(cd-hit-est -h | head -n 1 | sed 's/^.*====== CD-HIT version //;s/ (built on .*) ======//' )
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def suffix  = task.ext.suffix ?: "${sequences}" ==~ /(.*f[astn]*a(.gz)?$)/ ? "fa" : "fq"

    """
    touch ${meta.id}.${suffix}
    touch ${meta.id}.${suffix}.clstr

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cdhit: \$(cd-hit-est -h | head -n 1 | sed 's/^.*====== CD-HIT version //;s/ (built on .*) ======//' )
    END_VERSIONS
    """
}
