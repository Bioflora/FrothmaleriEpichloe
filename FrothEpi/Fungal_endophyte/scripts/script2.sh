#!/bin/bash

##################################################################################################
# README - Usage Instructions for script2.sh                                                     #
#                                                                                                #
# This script performs BLAST searches using a local nucleotide database created in order to      #
# detect multiple copies of the genes analyzed in this study (MSA files).                        #
#                                                                                                #
# Requirements:                                                                                  #
# - bash shell                                                                                   #
# - BLAST+ suite installed (makeblastdb, blastn)                                                 #
# - samtools                                                                                     #
#                                                                                                #
# Input files:                                                                                   #
# - Nucleotide genome files in FASTA format (.fna), already downloaded from NCBI using provided  #
#   accession numbers in directory "FrothEpi/Fungal_endophyte/data/Phylogenetic_analysis". Note  #
#   that this folder needs decompression prior to script execution.                              #
# - Prepared Multiple Sequence Alignments (MSA) stored in the directory                          #
#   "FrothEpi/Fungal_endophyte/data/Phylogenetic_analysis/MSA" without gaps and in their         #
#   original version in ("../originals")                                                         #                               
#                                                                                                #
# What the script does:                                                                          #
# - Creates a local BLAST nucleotide database from the .fna files                                #
# - Performs BLAST searches against the database using each MSA to detect multicopies            #
#                                                                                                #
# Make sure the script has execution permission:                                                 #
# $ chmod +x script2.sh                                                                          #
#                                                                                                #
# To run the script:                                                                             #
# $ bash script2.sh                                                                              #
#                                                                                                #
# Output:                                                                                        #
# - BLAST results will be saved within the working directory in the paths specified below.       #
#                                                                                                #
# Author: Sotomayor-Alge, Alba                                                                   #
# Date: 05-26-2025                                                                               #
##################################################################################################


##############
### STEP 1 ###
##############

# Alignment and database directories
ALIGNMENTS_DIR="../data/Phylogenetic_analysis/MSA"
DB_DIR="../data/Phylogenetic_analysis/Reference_genomes_NCBI"
OUTPUT_DIR="../data/Blast_Results"  # Main folder where results will be saved

# Create the main folder if it does not exist
mkdir -p "$OUTPUT_DIR"

# Name of the alignment that must run without "-qcov_hsp_perc 100"
EXCLUDED_ALIGNMENT="MSA_tefA_rmv.fasta"

# Loop through all alignment files in the folder
for aln_file in "$ALIGNMENTS_DIR"/*.fasta; do
    aln_name=$(basename "$aln_file")  # Get full name with extension
    aln_base=$(basename "$aln_file" .fasta)  # Get base name without extension

    # Create a specific folder for this alignment within the results folder
    aln_output_dir="$OUTPUT_DIR/$aln_base"
    mkdir -p "$aln_output_dir"

    # Loop through all databases in the folder
    for db_file in "$DB_DIR"/*.fna; do
        db_name=$(basename "$db_file" .fna)  # Extract database name without extension

        # Output file name
        output_file="${aln_base}_vs_${db_name}.txt"

        echo "Running BLAST for $aln_base against $db_name..."

        # If the alignment is "MSA_tef1_rmv.fasta", run without "-qcov_hsp_perc 100"
        if [[ "$aln_name" == "$EXCLUDED_ALIGNMENT" ]]; then
            /SOFT/blast/ncbi-blast-2.14.0+/bin/blastn -query "$aln_file" -db "$db_file" \
            -out "$output_file" -outfmt 6
            echo "❗ Executed without -qcov_hsp_perc 100 for $aln_name"
        else
            /SOFT/blast/ncbi-blast-2.14.0+/bin/blastn -query "$aln_file" -db "$db_file" \
            -out "$output_file" -outfmt 6 -qcov_hsp_perc 100
            echo "✅ Executed with -qcov_hsp_perc 100 for $aln_name"
        fi

        echo "Result saved to $output_file"

        # Move result file to the corresponding alignment folder
        mv "$output_file" "$aln_output_dir/"
    done
done



##############
### STEP 2 ###
##############

# Database (genomes) and BLAST results directories
DB_DIR="./Reference_genomes_NCBI"
BLAST_RESULTS_DIR="./Blast_Results"
OUTPUT_DB_DIR="./Extracted_DB_Sequences"  # Folder to store DB sequences

# Create output folder if it does not exist
mkdir -p "$OUTPUT_DB_DIR"

# Loop through all BLAST files in each subfolder
for BLAST_FILE in "$BLAST_RESULTS_DIR"/*/*.txt; do
    if [[ ! -s "$BLAST_FILE" ]]; then
        echo "⚠️  Skipping empty file: $BLAST_FILE"
        continue
    fi

    echo "🔍 Analyzing: $BLAST_FILE"

    # Extract exact database name from BLAST file name
    GENOME_DB=$(basename "$BLAST_FILE" | sed -E 's/^.*_vs_([^/]+)\.txt$/\1/')

    # Extract alignment name (example: "actG" from "MSA_actG_rmv_vs_GCA_000223075.2_E.amarillans_E57.txt")
    ALIGNMENT_NAME=$(basename "$BLAST_FILE" | sed -E 's/^MSA_([^_]+).*$/\1/')

    # Check if genome file exists in Reference_genomes_NCBI/
    GENOME_PATH="$DB_DIR/$GENOME_DB.fna"

    if [[ ! -f "$GENOME_PATH" ]]; then
        echo "❌ Error: Genome file '$GENOME_PATH' not found for BLAST results!"
        continue
    fi

    # Index the genome if not already indexed
    if [[ ! -f "$GENOME_PATH.fai" ]]; then
        echo "Indexing genome: $GENOME_PATH"
        samtools faidx "$GENOME_PATH"
    fi

    # Define the unique output file for all extracted sequences
    OUTPUT_FASTA="$OUTPUT_DB_DIR/${ALIGNMENT_NAME}_vs_${GENOME_DB}.fasta"
    > "$OUTPUT_FASTA"  # Clear file before writing

    # Temporary file to check for redundant regions
    TEMP_COORDS="temp_coords.txt"
    > "$TEMP_COORDS"

    # Extract all coordinates corresponding to each `query`
    awk '{print $2, $9, $10}' "$BLAST_FILE" | while read CHROM SSTART SEND; do

        # Ensure SSTART is less than SEND (corrects inversions)
        if [[ "$SSTART" -gt "$SEND" ]]; then
            TEMP="$SSTART"
            SSTART="$SEND"
            SEND="$TEMP"
        fi

        # Save the region in the temporary file
        echo "${CHROM}:${SSTART}-${SEND}" >> "$TEMP_COORDS"

    done

    # Check if all queries map to the same region
    UNIQUE_COUNT=$(sort "$TEMP_COORDS" | uniq | wc -l)

    if [[ "$UNIQUE_COUNT" -eq 1 ]]; then
        # If all queries map to the same region, save only one copy
        UNIQUE_COORD=$(sort "$TEMP_COORDS" | uniq | head -n1)
        echo ">${ALIGNMENT_NAME}_${GENOME_DB}_${UNIQUE_COORD}" >> "$OUTPUT_FASTA"
        samtools faidx "$GENOME_PATH" "$UNIQUE_COORD" >> "$OUTPUT_FASTA"
        echo "✔️ Only one unique sequence saved for $BLAST_FILE"
    else
        # If there are multiple regions, save each one separately
        sort "$TEMP_COORDS" | uniq | while read COORD_ID; do
            echo ">${ALIGNMENT_NAME}_${GENOME_DB}_${COORD_ID}" >> "$OUTPUT_FASTA"
            samtools faidx "$GENOME_PATH" "$COORD_ID" >> "$OUTPUT_FASTA"
        done
        echo "✔️ All unique sequences saved for $BLAST_FILE"
    fi

    echo "-------------------------------------------------"

    # Clean temporary files
    rm -f "$TEMP_COORDS"

done

echo "✅ Extraction complete! All DB sequences saved in $OUTPUT_DB_DIR/"

# Check which files contain more than one sequence and move those files to a new directory
# Create the "repeated" directory if it does not exist
mkdir -p Extracted_DB_Sequences/repeated

for fasta_file in Extracted_DB_Sequences/*.fasta; do
    if [[ -s "$fasta_file" ]]; then  # Check if the file is not empty
        count=$(tail -n +2 "$fasta_file" | grep -c "^>")  # Ignore the first line and count ">"
        real_count=$(( (count + 1) / 2 ))  # Every two ">" represent a single sequence
        if [[ "$real_count" -gt 1 ]]; then  # If more than one sequence, move file
            echo "📦 Moving $fasta_file → repeated/ (Contains $real_count sequences)"
            mv "$fasta_file" Extracted_DB_Sequences/repeated/
        fi
    fi
done

echo "📁 Files with multiple sequences have been moved to 'repeated/'"



##############
### STEP 3 ###
##############

for BLAST_FILE in Blast_Results/*/*.txt; do
    echo "🔍 Checking file: $BLAST_FILE"
    awk '{print $2, $1}' "$BLAST_FILE" | sort | uniq -c | awk '$1 > 1'
    echo "-------------------------------------------------"
done
