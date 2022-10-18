R Notebook
================

  - [Setup](#setup)
  - [Plot publication frequency](#plot-publication-frequency)

# Setup

``` r
library(data.table)
library(ggplot2)

# Web of Science citations
wosgenetics <- fread('data/web_of_science/WoS_2020-10-18_population_genetics_coral.txt') # pop genetics & coral in Topic
```

    ## Warning in fread("data/web_of_science/
    ## WoS_2020-10-18_population_genetics_coral.txt"): Found and resolved improper
    ## quoting in first 100 rows. If the fields are not quoted (e.g. field separator
    ## does not appear within any field), try quote="" to avoid this warning.

``` r
wosgenomics <- fread('data/web_of_science/WoS_2020-10-18_population_genomics_coral.txt') # pop genomics & coral in Topic

# transform
sumgenetics <- wosgenetics[, .(npubs = .N, class = 'genetics'), by = PY]
sumgenomics <- wosgenomics[, .(npubs = .N, class = 'genomics'), by = PY]
sum <- rbind(sumgenetics, sumgenomics)
```

# Plot publication frequency

``` r
ggplot(sum, aes(PY, npubs, color = class, group = class)) +
    geom_line()
```

    ## Warning: Removed 2 row(s) containing missing values (geom_path).

![](wos_pub_frequencies_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->
