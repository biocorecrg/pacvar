process SAWFISH_DISCOVER {
    tag "$meta.id"
    label 'process_high'
    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/sawfish:2.0.2--h9ee0642_0':
        'biocontainers/sawfish:2.0.2--h9ee0642_0' }"

    input:
    tuple val(meta), path(bam), path(bai)
    tuple val(meta2), path(fasta)
    path(expected_cn)  // optional
    path(cnv_excluded) // optional
    
    output:
    tuple val(meta), path("*_sawfish") , emit: outfolder
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args         = task.ext.args ?: ''
    def prefix       = task.ext.prefix ?: "${meta.id}"
    def expected_cn  = expected_cn ? " --expected-cn ${expected_cn}" : ""
    def cnv_excluded = cnv_excluded ? "--cnv-excluded-regions ${cnv_excluded}" : ""

    """
    sawfish \\
        discover \\
        --threads ${task.cpus} \\
        --ref ${fasta} $args ${expected_cn} ${cnv_excluded} \\
        --disable-path-canonicalization \\
        --bam ${bam} \\
        --output-dir ./${prefix}_sawfish
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sawfish: \$(sawfish --version |& sed '1!d ; s/sawfish //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mkdir ${prefix}_sawfish

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sawfish: \$(sawfish --version |& sed '1!d ; s/sawfish //')
    END_VERSIONS
    """
}
