#!/bin/sh

## Usage:
# bash example_prep.sh

## Example in JHPCE
## Have to run this manually, for now??
module load R/3.3.x
module load ucsctools
module load wiggletools/default

## Some common variables
DATADIR="/dcl01/leek/data/sunghee_analysis/processed/coverage_bigwigs"
COUNTS="/dcl01/leek/data/sunghee_analysis/processed/cross_sample_results/counts.tsv.gz"
BWTOOL="/dcl01/leek/data/bwtool/bwtool-1.0/bwtool"
WIGGLE="wiggletools"

## Download some required files
Rscript prep_setup.R

## Display help info on how to run prep_sample.R
Rscript prep_sample.R -h
## Note that if you setup the environment variable TMPDIR and export it, this
## will control where R stores the temporary files. See ?tempdir for more info.

## Process two samples
Rscript prep_sample.R -f ${DATADIR}/JH-13_GGCTAC_L006.bw -c ${COUNTS} -b ${BWTOOL} -w ${WIGGLE} -a TRUE
#Rscript prep_sample.R -f ${DATADIR}/JH-30_GTGAAA_L004.bw -c ${COUNTS} -b ${BWTOOL} -w ${WIGGLE} -a TRUE

## Use full arguments for another sample:
Rscript prep_sample.R --bigwig_file ${DATADIR}/JH-11_GGCTAC_L003.bw --counts_file ${COUNTS} --bwtool ${BWTOOL} --wiggletools ${WIGGLE}--calculate_auc TRUE

## Now merge results
paste rse_temp/counts_exon_* > counts_exon.tsv
gzip counts_exon.tsv
paste rse_temp/counts_gene_* > counts_gene.tsv
gzip counts_gene.tsv

## Display help info on how to run prep_merge.R
Rscript prep_merge.R -h

## Merge rse objects and create junction rse object
BWDIR="/dcl01/leek/data/sunghee_analysis/processed/coverage_bigwigs"
JUNCTIONS="/dcl01/leek/data/sunghee_analysis/processed/cross_sample_results/first_pass_junctions.tsv.gz"
MANIFEST="/dcl01/leek/data/sunghee/all_s3.manifest"
WIGTOBIGWIG="wigToBigWig"
Rscript prep_merge.R -b ${BWDIR} -j ${JUNCTIONS} -m ${MANIFEST} -w ${WIGGLE} -t ${WIGTOBIGWIG} -c TRUE
