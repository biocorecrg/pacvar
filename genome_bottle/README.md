# Genome in the bottle test

We analyzed the data from HG002_NA24385_son (AshkenazimTrio):
- Title of Dataset
PacBio HiFi (Revio) sequencing of the GIAB Ashekenazi Jewish Son (HG002) NIST Reference Material

- Background
HiFi whole genome sequencing of the GIAB Ashekenazi Jewish Family Trio NIST Reference Materials was performed by PacBio. HiFi reads were generated using the Revio system and aligned to three reference genomes; GRCh38-GIABv3, GRCh37 and CHM13.  


https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/AshkenazimTrio/HG002_NA24385_son/PacBio_HiFi-Revio_20231031/README_HG002-PacBio-Revio.md

## Benchamarking with hap.py 

The variants obtained using the DeepVariant pipeline tool were used for benchmarking.

The hap.py tool was run using the following files:

**Variant reference**

https://urldefense.com/v3/__https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/AshkenazimTrio/HG002_NA24385_son/latest/GRCh38/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf.gz__;!!D9dNQwwGXtA!TpqHM3mjHyuIqcPaYqg3T8YvPtPT3GEE8h82f6YsnuvhyU8TEszd7DJcaRkOl_E6Ovb5h8xdaDTui2KeLRfwlQBfNA$

```
reference=/users/bi/fandrade/projects/unicas_benchmarking/data/reference/HG002_GRCh38_1_22_v4.2.1_benchmark.vcf
```
cf **VCF from deepva
genome

```
deepvariant=/users/bi/fandrade/projects/unicas_benchmarking/data/deepvariant/SON.vcf
```

**Reference genome**

```
genome=/users/bi/sequencing_analysis/UNICAS_01/analysis/nf-core/pacvar/anno/GRCh38.primary_assembly.genome.fa
```

**Stratification**

https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/genome-stratifications/v3.6/genome-stratifications-bb-GRCh38@all.tar.gz

```
stratification=/users/bi/fandrade/projects/unicas_benchmarking/data/GRCh38@all/GRCh38-all-stratifications.tsv
```

### Running hap.py

```
singularity exec happy.sif /opt/hap.py/bin/hap.py $reference $deepvariant -o SON_strat -r $genome --stratification $stratification --threads 6
```
