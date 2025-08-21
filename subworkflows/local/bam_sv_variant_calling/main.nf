
include { SAWFISH_DISCOVER     } from '../../../modules/local/sawfish/discover/main'
include { SAWFISH_JOINT_CALL   } from '../../../modules/local/sawfish/joint-call/main'
include { BCFTOOLS_INDEX       } from '../../../modules/nf-core/bcftools/index/main'
include { TABIX_BGZIP          } from '../../../modules/nf-core/tabix/bgzip/main'


workflow BAM_SV_VARIANT_CALLING {
    take:
    sorted_bam
    sorted_bai
    fasta
    fasta_fai
    expected_cn
    cnv_excluded_regions

    main:
    ch_versions = Channel.empty()

    //call the structural variants
    input_aln = sorted_bam.join(sorted_bai)  // match by meta.id

    SAWFISH_DISCOVER(input_aln, fasta, expected_cn, cnv_excluded_regions)
    out_discover = SAWFISH_DISCOVER.out.outfolder.map { it[1] }  
        .collect()
        .map { paths -> [ [id: 'All'], paths ] 
    }
 
    all_bams = input_aln.concat(sorted_bai).map { it[1] }  
        .collect()
        .map { paths -> [ [id: 'All'], paths ] 
    }   
    
                
    SAWFISH_JOINT_CALL(out_discover, all_bams, fasta)

/*
    //zip and index
    TABIX_BGZIP(PBSV_CALL.out.vcf)
    BCFTOOLS_INDEX(TABIX_BGZIP.out.output)

    vcf_ch = TABIX_BGZIP.out.output.join(BCFTOOLS_INDEX.out.csi)

    ch_versions = ch_versions.mix(SAWFISH_DISCOVER.out.versions)
    ch_versions = ch_versions.mix(PBSV_CALL.out.versions)
    ch_versions = ch_versions.mix(TABIX_BGZIP.out.versions)
    ch_versions = ch_versions.mix(BCFTOOLS_INDEX.out.versions)
    */
    
    vcf_ch         = Channel.empty()
    
    emit:
    vcf_ch
    versions       = ch_versions

}

