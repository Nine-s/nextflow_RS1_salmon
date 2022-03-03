process STAR_INDEX_REFERENCE {
    label 'star'
    publishDir params.outdir
    memory '50 GB'
    executor 'k8s'
    
    input:
    path(reference)
    path(annotation)

    output:
    path("star/*")

    script:
    """
    mkdir star
    STAR \\
            --runMode genomeGenerate \\
            --genomeDir star/ \\
            --genomeFastaFiles ${reference} \\
            --sjdbGTFfile ${annotation} \\
            --runThreadN ${params.threads} \\
	
    """
}

process STAR_ALIGN {
    label 'star'
    publishDir params.outdir
    memory '50 GB'
    executor 'k8s'
    
    input:
    tuple val(sample_name), path(reads)
    path(index)
    path(annotation)

    output:
    tuple val(sample_name), path("${sample_name}*.sam"), emit: sample_sam 

    script:
    """
    STAR \\
        --genomeDir . \\
        --readFilesIn ${reads[0]} ${reads[1]}  \\
        --readFilesCommand gunzip -c \\
        --runThreadN ${params.threads} \\
        --outFileNamePrefix ${sample_name}. \\
        --sjdbGTFfile ${annotation}

    """
}
