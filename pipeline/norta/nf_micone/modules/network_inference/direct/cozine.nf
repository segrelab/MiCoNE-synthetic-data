include { getHierarchy; updateMeta } from '../../../functions/functions.nf'

process cozine {
    label 'cozine'
    tag "${new_meta.id}"
    publishDir "${params.output_dir}/${f[0]}/${f[1]}/${f[2]}/${directory}/${new_meta.id}",
        mode: 'copy',
        overwrite: true
    input:
        tuple val(meta), file(otu_file), file(obs_metadata), file(sample_metadata), file(children_map)
    output:
        tuple val(new_meta), file('*_corr.tsv'), file(obs_metadata), file(sample_metadata), file(children_map)
    when:
        'cozine' in params.network_inference.direct['selection']
    script:
        new_meta = updateMeta(meta)
        new_meta.network_inference = 'cozine'
        String task_process = "${task.process}"
        f = getHierarchy(task_process)
        directory = "${new_meta.denoise_cluster}-${new_meta.chimera_checking}-${new_meta.tax_assignment}-${new_meta.tax_level}"
        lambda_min_ratio = params.network_inference.direct['cozine']['lambda_min_ratio']
        template 'network_inference/direct/cozine.R'
}
