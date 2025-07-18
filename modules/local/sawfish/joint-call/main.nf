process SAWFISH_JOINT_CALL {
    tag "$meta.id"
    label 'process_high'
    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/sawfish:2.0.2--h9ee0642_0':
        'biocontainers/sawfish:2.0.2--h9ee0642_0' }"

    input:
    tuple val(meta), path(discover_folders)
    tuple val(meta2), path(bams)
    tuple val(meta3), path(fasta)
    
    output:
    tuple val(meta), path("*_joint_call") , emit: joint_calls
    path "versions.yml"                   , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args         = task.ext.args ?: ''
    def prefix       = task.ext.prefix ?: "${meta.id}"
    def sample_pars  = "--sample " + discover_folders.join(" --sample ")

    """ 
    sawfish joint-call --threads ${task.cpus} ${sample_pars} $args --output-dir ./${prefix}_joint_call
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
