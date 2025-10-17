# FrothmaleriEpichloe

```
The project is organized under the main directory FrothEpi/, structured into two major modules: Plant_host/ and 
Fungal_endophyte/. Each module contains data, scripts, and outputs corresponding to specific stages of the analysis.
Folder system as follows:

FrothEpi/
│
├── Plant_host/
│   └── data/
│       ├── chromcount_host.xlsx               # Chromosome count data for the three cytotypes of Festuca rothmaleri.
│       │                                      Variables: EndophyteID (sample identification code);
│       │                                      IndshortID (short name for each isolate);
│       │                                      repID (replicate code within each isolate);
│       │                                      Plo_pop (interaction between the population of origin and ploidy level);
│       │                                      pictureID (picture identification code).
│       │                                                                           
│       └── flow_cytometry_host.xlsx           # Genome size estimations via flow cytometry for F. rothmaleri cytotypes.
│                                              Variables: Sample_ID (sample identification code);
│                                              Plo_pop (interaction between the population of origin and ploidy level); 
│                                              measurement_ID (measurement identification code);
│                                              nucleids (number of particles counted in the sample); 
│                                              nucleids_STD (number of particles counted in the standard); 
│                                              mean (arithmetic mean of the fluorescence intensities of all particles included in the sample); 
│                                              mean_STD (arithmetic mean of the fluorescence intensities of all particles included in the standard);
│                                              CV (coefficient of Variation of the sample); 
│                                              CV_STD (coefficient of Variation of the standard);
│                                              pg/2C (estimated genome size of the sample); 
│                                              pg/2C_STD (known genome size of the standard);
│                                              meanGS_Sample (mean genome size per isolate); 
│                                              SD_Sample (Standard deviation per isolate);
│                                              meanGS_Plopop (genome size value per population of origin and host ploidy level); 
│                                              SD_Plopop (standard deviation value per population of origin and host ploidy level).                                               
│
│
│
│
├── Fungal_endophyte/
│   ├── data/
│   │   ├── outputs_script1/                   # Output files of the morphological analyses (from script1.Rmd)
│   │   ├── outputs_script3/                   # Single-gene, species tree and concatenated ML files (from script3.sh)
│   │   ├── outputs_script4/                   # Formatted phylogenetic trees (from script4.Rmd)
│   │   ├── Phylogenetic_analysis/
│   │   │   │  
│   │   │   ├── MSA/                           # Cleaned multiple sequence alignments and originals (FASTA format)
│   │   │   │  
│   │   │   ├── PP_values_ASTRAL_SPTREE.xlsx   # Posterior probability values for each node of the ASTRAL phylogenetic tree. Input script4.Rmd.
│   │   │   ├── Q_values_ASTRAL_SPTREE.xlsx    # Quartet values for each node of the ASTRAL phylogenetic tree. Input script4.Rmd.
│   │   │   ├── UFBoot_values_actG.xlsx        # UltraFast bootstrap values for each node in the actG phylogenetic tree. Input script4.Rmd.
│   │   │   ├── UFBoot_values_CalM.xlsx        # UltraFast bootstrap values for each node in the CalM phylogenetic tree. Input script4.Rmd.
│   │   │   ├── UFBoot_values_ITS.xlsx         # UltraFast bootstrap values for each node in the ITS phylogenetic tree. Input script4.Rmd.
│   │   │   ├── UFBoot_values_tefA.xlsx        # UltraFast bootstrap values for each node in the tefA phylogenetic tree. Input script4.Rmd.
│   │   │   ├── UFBoot_values_tubB.xlsx        # UltraFast bootstrap values for each node in the tubB phylogenetic tree. Input script4.Rmd.
│   │   │   └── UFBoot_and_scfl_values_MLtree  # UltraFast bootstrap and SCFL values for each node in the ML phylogeentic tree. Input script4.Rmd.
│   │   │   
│   │   ├── culture_growth_dataset.csv         # Dataset for culture growth rate analysis (used in script1.Rmd).
│   │   │                                      This file is semicolon-delimited and uses a comma as the decimal separator.
│   │   │                                      Variables: IndID (measurement identification code);
│   │   │                                      Ind (short name for each isolate);
│   │   │                                      Ploidy (host ploidy level);
│   │   │                                      Pop (Population of origin);
│   │   │                                      Rep (replicate code within each isolate);
│   │   │                                      Day (Day the measurement was made);
│   │   │                                      Diameter (diameter of the culture in mm)
│   │   │     
│   │   ├── spores_dataset.csv                 # Morphometric data of asexual reproductive structures (used in script1.Rmd). 
│   │   │                                      This file is semicolon-delimited and uses a comma as the decimal separator.
│   │   │                                      Variables: SampleID (measurement identification code); 
│   │   │                                      Ind (short name for each isolate);   
│   │   │                                      conidW (conidial width in μm); 
│   │   │                                      conidL (conidial length in μm); 
│   │   │                                      conidiophL (conidiophore length in μm);
│   │   │                                      conidiophW (conidiophore width in μm); 
│   │   │                                      conidA (conidial area in μm²); 
│   │   │                                      Pop (Population of origin);
│   │   │                                      Ploidy (host ploidy level).
│   │   │             
│   │   └── flow_cytometry_endophyte.xlsx      # Genome size estimations of Epichloë festucae via flow cytometry.
│   │                                          Variables: Plo_pop (interaction between the population of origin and ploidy level);
│   │                                          Sample_ID (sample identification code); 
│   │                                          Measurement_ID (measurement identification code);
│   │                                          nucleids (number of particles counted in the sample); 
│   │                                          nucleids_STD (number of particles counted in the standard); 
│   │                                          mean (arithmetic mean of the fluorescence intensities of all particles included in the sample); 
│   │                                          mean_STD (arithmetic mean of the fluorescence intensities of all particles included in the standard);
│   │                                          CV (coefficient of Variation of the sample); 
│   │                                          CV_STD (coefficient of Variation of the standard);
│   │                                          pg/1C (estimated genome size of the sample); 
│   │                                          pg/1C_STD (known genome size of the standard);
│   │                                          meanGS_Sample (mean genome size per isolate); 
│   │                                          SD_Sample (Standard deviation per isolate);
│   │                                          global_GS (global genome size value); 
│   │                                          global_SD (global standard deviation).                    
│   │
│   └── scripts/
│       ├── script1.Rmd                       # RMarkdown: Morphological analysis of fungal endophyte.
│       ├── script2.sh                        # Shell script: Detection of multiple gene copies in reference genomes.
│       ├── script3.sh                        # Shell script: Phylogenetic inference using IQ-TREE2 and ASTRAL.
│       └── script4.Rmd                       # RMarkdown: Visualization and editing of phylogenetic trees.
└

```

