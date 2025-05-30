# FrothmaleriEpichloe

```
The project is organized under the main directory FrothEpi/, structured into two major modules: Plant host and Fungal 
endophyte. Each module contains data, scripts, and outputs corresponding to specific stages of the analysis. Folder 
system as follows:

FrothEpi/
│
├── Plant_host/
│   └── data/
│       ├── chromcount_host.xlsx              # Chromosome count data for the three cytotypes of Festuca rothmaleri
│       └── flow_cytometry_host.xlsx          # Genome size estimations via flow cytometry for F. rothmaleri cytotypes
│
├── Fungal_endophyte/
│   ├── data/
│   │   ├── outputs_script1/                  # Output of morphological analyses (from script1.Rmd)
│   │   ├── outputs_script3/                  # Single-gene, species tree and concatenated ML files (from script3.sh)
│   │   ├── outputs_script4/                  # Formatted phylogenetic trees (from script4.Rmd)
│   │   ├── Phylogenetic_analysis/
│   │   │   ├── MSA/                          # Cleaned multiple sequence alignments and originals (FASTA format)
│   │   │   ├── Reference_genomes_NCBI.zip/   # Reference genomes used (.fna files, zipped)
│   │   │   └── .xlsx files                   # Additional tree support metrics (e.g., quartet values, SCFL). Input script4.Rmd.
│   │   ├── culture_growth_dataset.csv        # Dataset for culture growth rate analysis (used in script1.Rmd)
│   │   ├── spores_dataset.csv                # Morphometric data of asexual reproductive structures (used in script1.Rmd)
│   │   └── flow_cytometry_endophyte.xlsx     # Genome size estimations of Epichloë festucae via flow cytometry
│
│   └── scripts/
│       ├── script1.Rmd                       # RMarkdown: Morphological analysis of fungal endophyte
│       ├── script2.sh                        # Shell script: Detection of multiple gene copies in reference genomes
│       ├── script3.sh                        # Shell script: Phylogenetic inference using IQ-TREE2 and ASTRAL
│       └── script4.Rmd                       # RMarkdown: Visualization and editing of phylogenetic trees
```

