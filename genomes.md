Identify coral reef genome assemblies
================

  - [Set up and load data](#set-up-and-load-data)
  - [Find reef-associated taxa from Fishbase and
    Sealifebase](#find-reef-associated-taxa-from-fishbase-and-sealifebase)
  - [Mark reef species in NCBI](#mark-reef-species-in-ncbi)
  - [Identify a preferred genome for each
    species](#identify-a-preferred-genome-for-each-species)
  - [Output list of reef genomes](#output-list-of-reef-genomes)
  - [Plot of genomes available](#plot-of-genomes-available)

## Set up and load data

``` r
library(data.table)
library(rfishbase)
print(paste('Using newest of Fishbase available releases:', paste(available_releases(server = 'fishbase'), collapse = ', ')))
```

    ## [1] "Using newest of Fishbase available releases: 21.06, 19.04"

``` r
print(paste('Using newest of Sealifebase available releases:', paste(available_releases(server = 'sealifebase'), collapse = ', ')))
```

    ## [1] "Using newest of Sealifebase available releases: 19.04, 21.11"

``` r
library(here)
```

    ## here() starts at /Users/mpinsky/Documents/Rutgers/ARG coral reef review/arg_coral_reefs

``` r
ncbi <- fread(here('data', 'ncbi', 'eukaryotes.csv')) # throws a warning about improper quoting, but appears to load correctly anyway
```

    ## Warning in fread(here("data", "ncbi", "eukaryotes.csv")): Found and
    ## resolved improper quoting out-of-sample. First healed line 4436:
    ## <<"Penstemon barbatus","Eukaryota;Plants;Land Plants","\"Duke\"
    ## line","SAMN09598766","PRJNA479669","GCA_003313485.1","Contig",
    ## 696.306,0,,"QOIQ01",18827,0,"2018-07-11T00:00:00Z",,>>. If the fields are not
    ## quoted (e.g. field separator does not appear within any field), try quote="" to
    ## avoid this warning.

``` r
setnames(ncbi, old = c('#Organism Name', 'Organism Groups', 'Size(Mb)', 'GC%', 'Release Date', 'GenBank FTP'), new = c('OrganismName', 'OrganismGroups', 'SizeMb', 'GBpercent', 'ReleaseDate', 'GenBankFTP'))
ncbi[, Level := gsub(' ', '', Level)]
```

## Find reef-associated taxa from Fishbase and Sealifebase

``` r
# get reef-associated taxa
slsppcodes <- data.table(fb_tbl('ecology', 'sealifebase'))[as.logical(CoralReefs)==TRUE, .(SpecCode, CoralReefs)] # reef species codes in sealifebase
```

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10011 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10000 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10001 milliseconds
    
    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10001 milliseconds

``` r
fbsppcodes <- data.table(fb_tbl('ecology', 'fishbase'))[as.logical(CoralReefs)==TRUE, .(SpecCode, CoralReefs)] # and in fishbase
```

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10004 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10005 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10007 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10001 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10000 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10002 milliseconds

``` r
print(paste('Found', nrow(slsppcodes), 'spp from Sealifebase')) # 3888
```

    ## [1] "Found 3888 spp from Sealifebase"

``` r
print(paste('Found', nrow(fbsppcodes), 'spp from Fishbase')) # 2430
```

    ## [1] "Found 2430 spp from Fishbase"

``` r
# get their species names
slspp <- data.table(fb_tbl('species', 'sealifebase'))[SpecCode %in% slsppcodes$SpecCode, .(SpecCode, Genus, Species, FBname, FamCode)]
```

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10003 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10000 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10001 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10003 milliseconds

``` r
fbspp <- data.table(fb_tbl('species', 'fishbase'))[SpecCode %in% fbsppcodes$SpecCode, .(SpecCode, Genus, Species, FBname, FamCode)]
```

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10001 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10002 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10004 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10003 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10004 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10000 milliseconds

``` r
# get their phylum/class/order/family
slfam <- data.table(fb_tbl('families', 'sealifebase'))
```

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10005 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10002 milliseconds
    
    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10002 milliseconds
    
    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10002 milliseconds

``` r
fbfam <- data.table(fb_tbl('families', 'fishbase'))
```

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10000 milliseconds
    
    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10002 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10005 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10002 milliseconds
    
    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10002 milliseconds

    ## Warning: Error in curl::curl_fetch_memory(file, handle): Timeout was reached: [hash-archive.org] Connection timed out after 10001 milliseconds

``` r
slspp <- merge(slspp, slfam[, .(FamCode, Family, Order, Class, Phylum)], all.x = TRUE, by = 'FamCode')
fbspp <- merge(fbspp, fbfam[, .(FamCode, Family, Order, Class)], all.x = TRUE, by = 'FamCode')
fbspp[, Phylum := 'Chordata']
```

## Mark reef species in NCBI

``` r
# Sealifebase
slmatches <- sapply(slspp[, paste(Genus, Species)], grep, ncbi$OrganismName) # grep for Genus species
slmatchnum <- sapply(slmatches, length) # number of matches for each species
print(paste('SL species with genomes:', length(slmatchnum[slmatchnum > 0]))) # number of sealifebase reef species with an NCBI match. 74
```

    ## [1] "SL species with genomes: 74"

``` r
# Fishbase
fbmatches <- sapply(fbspp[, paste(Genus, Species)], grep, ncbi$OrganismName) # grep for Genus species
fbmatchnum <- sapply(fbmatches, length) # number of matches for each species
print(paste('FB species with genomes:', length(fbmatchnum[fbmatchnum > 0]))) # fishbase reef species with an NCBI match. finds 75.
```

    ## [1] "FB species with genomes: 75"

``` r
# mark genomes that are reef species
ncbi[, ":="(CoralReef = FALSE, Family = NA_character_, Order = NA_character_, Class = NA_character_, Phylum = NA_character_)]
for(i in 1:length(slmatches)){ # for each sealifebase species
    if(length(slmatches[[i]])>0){
        j <- slspp[, which(paste(Genus, Species) == names(slmatches)[i])]
        if(length(j) != 1) stop(paste('i=', i, 'and found more than one row in slspp with this Genus Species'))
        ncbi[slmatches[[i]], ":="(CoralReef = TRUE, Family = slspp$Family[j], Order = slspp$Order[j], Class = slspp$Class[j], Phylum = slspp$Phylum[j])] # adds metadata to all matching genomes. note that some spp have multiple genomes on NCBI    
    }
}
for(i in 1:length(fbmatches)){ # for each fishbase species
    if(length(fbmatches[[i]])>0){
        j <- fbspp[, which(paste(Genus, Species) == names(fbmatches)[i])]
        if(length(j) != 1) stop(paste('i=', i, 'and found more than one row in fbspp with this Genus Species'))
        ncbi[fbmatches[[i]], ":="(CoralReef = TRUE, Family = fbspp$Family[j], Order = fbspp$Order[j], Class = fbspp$Class[j], Phylum = fbspp$Phylum[j])] # adds metadata to all matching genomes. note that some spp have multiple genomes on NCBI    
    }
}
ncbi <- ncbi[CoralReef == TRUE, ]
print(paste('Genomes from reef species:', ncbi[, .N]))
```

    ## [1] "Genomes from reef species: 194"

## Identify a preferred genome for each species

Some species have multiple genomes. Choose chromosome \> scaffold \>
contig, then choose the newest release date, then the largest.

``` r
ncbi[, selectedGenome := FALSE]
sppnames <- ncbi[, unique(OrganismName)]
for(i in 1:length(sppnames)){
    j <- ncbi[, which(OrganismName == sppnames[i])]
    if(length(j)==0) stop(paste('i=', i, 'but could not find it in ncbi data.table'))
    if(length(j)==1) ncbi[j, selectedGenome := TRUE] # if only one species, mark it
    if(length(j)>1){
        j <- ncbi[, which(Level == 'Chromosome' & OrganismName == sppnames[i])]
        if(length(j)>0){
            if(length(j)==1) ncbi[j, selectedGenome := TRUE] # if only one chromosome-scale assembly, mark it
            if(length(j)>1){
                maxDate <- ncbi[j, max(as.Date(ReleaseDate))]
                j <- ncbi[, which(Level == 'Chromosome' & OrganismName == sppnames[i] & as.Date(ReleaseDate) == maxDate)] # find the newest chromosome-scale assembly
                if(length(j)==1) ncbi[j, selectedGenome := TRUE] # mark it
                if(length(j)>1){
                    maxSize <- ncbi[j, max(SizeMb)]
                    j <- ncbi[, which(Level == 'Chromosome' & OrganismName == sppnames[i] & as.Date(ReleaseDate) == maxDate & SizeMb == maxSize)] # find the largest chromosome-scale assembly
                    if(length(j)==1) ncbi[j, selectedGenome := TRUE] # mark it
                    if(length(j)>1) stop(paste('i=', i, ', need to handle the case when multiple chromosome-scale assemblies have the same release date and size'))
                } 
            }
        }
        if(length(j) == 0){
            j <- ncbi[, which(Level == 'Scaffold' & OrganismName == sppnames[i])]
            if(length(j)>0){
                if(length(j)==1) ncbi[j, selectedGenome := TRUE] # if only one scaffold-scale assembly, mark it
                if(length(j)>1){
                    maxDate <- ncbi[j, max(as.Date(ReleaseDate))]
                    j <- ncbi[, which(Level == 'Scaffold' & OrganismName == sppnames[i] & as.Date(ReleaseDate) == maxDate)] # find the newest scaffold-scale assembly
                    if(length(j)==1) ncbi[j, selectedGenome := TRUE] # mark it
                    if(length(j)>1){
                        maxSize <- ncbi[j, max(SizeMb)]
                        j <- ncbi[, which(Level == 'Scaffold' & OrganismName == sppnames[i] & as.Date(ReleaseDate) == maxDate & SizeMb == maxSize)] # find the largest scaffolds-scale assembly
                        if(length(j)==1) ncbi[j, selectedGenome := TRUE] # mark it
                        if(length(j)>1) stop(paste('i=', i, ', need to handle the case when multiple scaffold-scale assemblies have the same release date and size'))
                    }
                }
            }
            if(length(j) == 0){
                j <- ncbi[, which(Level == 'Contig' & OrganismName == sppnames[i])]
                if(length(j)>0){
                    if(length(j)==1) ncbi[j, selectedGenome := TRUE] # if only one contig-scale assembly, mark it
                    if(length(j)>1){
                        maxDate <- ncbi[j, max(as.Date(ReleaseDate))]
                        j <- ncbi[, which(Level == 'Contig' & OrganismName == sppnames[i] & as.Date(ReleaseDate) == maxDate)] # find the newest contig-scale assembly
                        if(length(j)==1) ncbi[j, selectedGenome := TRUE] # mark it
                        if(length(j)>1){
                            maxSize <- ncbi[j, max(SizeMb)]
                            j <- ncbi[, which(Level == 'Contig' & OrganismName == sppnames[i] & as.Date(ReleaseDate) == maxDate & SizeMb == maxSize)] # find the largest chromosome-scale assembly
                            if(length(j)==1) ncbi[j, selectedGenome := TRUE] # mark it
                            if(length(j)>1) stop(paste('i=', i, ', need to handle the case when multiple contig-scale assemblies have the same release date and size'))
                        }
                    }
                } else {
                    stop(paste('i=', i, ', but could not find even a contig-scale assembly'))
                }
            }
        }
    }
}

# check
print(paste('Number of reef species genomes:', ncbi[, .N]))
```

    ## [1] "Number of reef species genomes: 194"

``` r
print(paste('Number of selected genomes:', ncbi[selectedGenome==TRUE, .N]))
```

    ## [1] "Number of selected genomes: 150"

``` r
print(paste('Min number of selected genomes per species (should be 1):', ncbi[, .(num = sum(selectedGenome)), by = OrganismName][, min(num)]))
```

    ## [1] "Min number of selected genomes per species (should be 1): 1"

``` r
print(paste('Max number of selected genomes per species (should be 1):', ncbi[, .(num = sum(selectedGenome)), by = OrganismName][, max(num)]))
```

    ## [1] "Max number of selected genomes per species (should be 1): 1"

## Output list of reef genomes

Some slight column renaming so easier to read into R in the future.

``` r
write.csv(ncbi[, .(OrganismName, Phylum, Class, Order, Family, OrganismGroups, Strain, BioSample, BioProject, Assembly, Level, SizeMb, GBpercent, WGS, Scaffolds, CDS, ReleaseDate, GenBankFTP, selectedGenome)], file = here('tables', 'reefgenomes.csv'), row.names = FALSE)
```

## Plot of genomes available

``` r
# make a list of the taxonomic groups we want to show
taxonnames = ncbi[selectedGenome == TRUE, .(Order, Class, Phylum)]
taxonnames[, show := Phylum] # generally show Phylum
taxonnames[Phylum == 'Chordata', show := Class] # for fishes, show class
taxonnames[Phylum != 'Cnidaria' & Phylum != 'Chordata', show := 'Other non-Chordates']
levs = taxonnames[, unique(show)]
levs <- levs[order(levs)]
i = which(levs == 'Cnidaria'); levs = c(levs[-i], levs[i]) # move Cnidarians to end of list
i = which(levs == 'Other non-Chordates'); levs = c(levs[-i], levs[i]) # move other inverts to end of list
taxonnames[, show := factor(show, levels = levs)]

# display
genome_table = table(ncbi[selectedGenome == TRUE, factor(Level, levels = c('Chromosome', 'Scaffold', 'Contig'))], taxonnames[, show]) # also re-order the factor levels
cols = c('#111111', '#999999', '#DDDDDD')
par(mai = c(2.5, 2, 0, 0))
barplot(genome_table, beside = TRUE, cex.names = 0.7, las = 2, ylab = 'Number of species', col = cols)
legend('top', legend = rownames(genome_table), cex = 0.5, fill = cols, bty = 'n')
```

![](genomes_files/figure-gfm/plot-1.png)<!-- -->

``` r
# output to file
png(filename = here('figures', 'fig4.png'), width=4, height = 2, units = 'in', res = 300)
par(mai = c(1, 0.8, 0, 0))
barplot(genome_table, beside = TRUE, cex.names = 0.5, cex.axis = 0.5, cex.lab = 0.5, las = 2, ylab = 'Number of species', col = cols)
legend('top', legend = rownames(genome_table), cex = 0.5, bty = 'n', fill = cols)
dev.off()
```

    ## quartz_off_screen 
    ##                 2
