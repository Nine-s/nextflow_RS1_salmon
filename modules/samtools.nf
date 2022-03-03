process SAMTOOLS {
    label 'samtools'
    publishDir params.outdir
    
    input:
    tuple val(sample_name), path(bam_file)
    
    output:
    tuple val(sample_name), path("${sample_name}.sorted.bam"), emit: sample_bam 
    
    script:
    """
    samtools sort ${bam_file} -o ${sample_name}.sorted.bam -T tmp  -@ ${params.threads} 
    """
    
}
