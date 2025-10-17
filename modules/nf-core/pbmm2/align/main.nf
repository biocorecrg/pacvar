process PBMM2_ALIGN {
    tag "$meta.id"
    label 'process_high'


    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'quay.io/biocontainers/pbmm2:1.17.0--h9ee0642_0': 'quay.io/biocontainers/pbmm2:1.17.0--h9ee0642_0' }"

    input:
    tuple val(meta), path(bam)
    tuple val(meta2), path(fasta)

    output:
    tuple val(meta), path("*.bam"), emit: bam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args          = task.ext.args ?: ''
    def prefix        = task.ext.prefix ?: "${meta.id}"
    def input_content = bam.join("\n")

    """
    # pbmm2 doesn't support .fna extension, so rename to .fa
    if [[ ${fasta} == *.fna ]]; then
        ln -s \$(readlink -f ${fasta}) \${${fasta}‰.fna}.fa
    elif [[ ${fasta} == *.fna.gz ]]; then
        ln -s \$(readlink -f ${fasta}) \${${fasta}‰.fna.gz}.fa.gz
    fi
    
    # create a fof for multiple bams
    echo "${input_content}" >> myfiles.fofn

    pbmm2 \\
        align \\
        $args \\
        $fasta \\
        myfiles.fofn \\
        ${prefix}.bam \\
        --num-threads ${task.cpus}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pbmm2: \$(pbmm2 --version |& sed '1!d ; s/pbmm2 //')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pbmm2: \$(pbmm2 --version |& sed '1!d ; s/pbmm2 //')
    END_VERSIONS
    """
}
