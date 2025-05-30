#!/bin/bash

##################################################################################################
# README - Usage Instructions for script3.sh                                                     #
#                                                                                                #
# This script creates the single-gene phylogenis, the species phylogenetic tree and the ML       #
# (concatenated) phylogenetic tree using the  genes analyzed in this study (MSA files).          #
#                                                                                                #
# Requirements:                                                                                  #
# - bash shell                                                                                   #
# - IQTREE2 (alias iq2='/bioflora/SOFT/iqtree-2.2.2.6-Linux/bin/iqtree2' asigned)                #
# - ASTRAL-III (alias astral='java -jar /bioflora/SOFT/ASTRAL/Astral/astral.5.7.8.jar') asigned  #                                                                                    
#                                                                                                #
# Input files:                                                                                   #
# - Individual Multiple Sequence Alignments (MSAs) files in FASTA format and concatenated MSA    #
#   stored in directory "FrothEpi/Fungal_endophyte/data/Phylogenetic_analysis/MSA/originals"     #
#   and partitions file for the ML phylogenetic tree.						 #                                                                                 
#                                                                                                #
# What the script does:                                                                          #
# - Generate all phylogenetic trees described above.                                             #
#                                                                                                #
# Make sure the script has execution permission:                                                 #
# $ chmod +x script3.sh                                                                          #
#                                                                                                #
# To run the script:                                                                             #
# $ bash script3.sh                                                                              #
#                                                                                                #
# Output:                                                                                        #
# - Single-gene phylogenetic trees + ML concatenated tree (IQTREE2); and species tree (ASTRAL).  #
#                                                                                                #
# Author: Sotomayor-Alge, Alba                                                                   #
# Date: 05-26-2025                                                                               #
##################################################################################################


# Define input and output directories
ALIGNMENTS_DIR="../data/Phylogenetic_analysis/MSA/originals"
OUTPUT_DIR="../data/outputs_script3"
mkdir -p "$OUTPUT_DIR"

# Move to output directory
cd "$OUTPUT_DIR" || exit



##################################
### SINGLE-GENE TREES (IQTREE2) ##
##################################

# List of gene names (without file extension)
GENES=("actG" "CalM" "ITS" "tefA" "tubB")

# Loop through each gene and run IQ-TREE
for GENE in "${GENES[@]}"; do
  iq2 -s "${ALIGNMENTS_DIR}/MSA_${GENE}.fasta" \
      -m MFP+MERGE \
      -nt AUTO \
      -o C.purpurea_LM04 \
      -B 1000 \
      --bnni \
      --prefix "MSA_${GENE}_UFBoot1000"
done



##########################################
### SPECIES TREE (ASTRAL-III, ALL -t)  ###
##########################################

# Concatenate all .treefile files into one
> Concat_5genes.trees  # Empty the file first
for GENE in "${GENES[@]}"; do
  cat "MSA_${GENE}_UFBoot1000.treefile" >> Concat_5genes.trees
done

# Run ASTRAL with -t 3 (posterior probabilities)
astral -i Concat_5genes.trees \
       -t 3 \
       -o ASTRAL_SPTREE_PP.tree

# Run ASTRAL with -t 8 (quartet scores)
astral -i Concat_5genes.trees \
       -t 8 \
       -o ASTRAL_SPTREE_Q.tree



##################################
### CONCATENATED TREE (IQTREE2) ##
##################################

# Run ML tree on concatenated alignment and partition file
iq2 -s "${ALIGNMENTS_DIR}/MSA_concat.fasta" \
    -m MFP+MERGE \
    -nt AUTO \
    -o C.purpurea_LM04 \
    -B 1000 \
    -p "${ALIGNMENTS_DIR}/partitions_ML.txt" \
    --prefix MSA_concat_UFBoot1000

# Calculate SCFL values
iq2 -te MSA_concat_UFBoot1000.treefile \
    -s "${ALIGNMENTS_DIR}/MSA_concat.fasta" \
    -p "${ALIGNMENTS_DIR}/partitions_ML.txt" \
    --scfl 1000 \
    --prefix ML_TREE \
    --keep-ident
