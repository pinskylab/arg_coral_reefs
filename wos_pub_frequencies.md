R Notebook
================

  - [Setup](#setup)
  - [Plot publication number](#plot-publication-number)
  - [Plot publication fraction](#plot-publication-fraction)

# Setup

``` r
library(data.table)
library(ggplot2)

# Web of Science citations
wosgenetics <- fread('data/web_of_science/WoS_2020-10-18_population_genetics_coral.txt', quote = "") # pop genetics & coral in Topic
wosgenomics <- fread('data/web_of_science/WoS_2020-10-18_population_genomics_coral.txt', quote = "") # pop genomics & coral in Topic
for(i in 1:25){
    if(i ==1) wosall <- fread('data/web_of_science/WoS_2020-10-18_population_genomics_1.txt', quote = "") # pop genomics in Topic, tranch 1
    if(i>1){
        temp <-fread(paste0('data/web_of_science/WoS_2020-10-18_population_genomics_', i, '.txt', quote = "")) # pop genomics in Topic, tranch i 
        wosall <- rbind(wosall, temp)
    }
}
```

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## in first 100 rows. If the fields are not quoted (e.g. field separator does not
    ## appear within any field), try quote="" to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting out-
    ## of-sample. First healed line 612: <<J Rougeron, V; De Meeus, T; Ouraga, SK;
    ## Hide, M; Banuls, AL Rougeron, Virginie; De Meeus, Thierry; Ouraga, Sandrine
    ## Kako; Hide, Mallorie; Banuls, Anne-Laure "Everything You Always Wanted to
    ## Know about Sex (but Were Afraid to Ask)" in Leishmania after Two Decades of
    ## Laboratory and Field Analyses PLOS PATHOGENS Rougeron, Virginie/AAH-7447-2020
    ## HIDE, Mallorie/0000-0001-5364-3032; Rougeron, Virginie/0000-0001-5873-5681;
    ## Banuls, Anne-Laure/0000-0002-2106-8667 1553-736>>. If the fields are not quoted
    ## (e.g. field separator does not appear within any field), try quote="" to avoid
    ## this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## out-of-sample. First healed line 341: <<J Martinu, J; Stefka, J; Poosakkannu,
    ## A; Hypsa, V Martinu, Jana; Stefka, Jan; Poosakkannu, Anbu; Hypsa, Vaclav
    ## "Parasite turnover zone" at secondary contact: A new pattern in host-parasite
    ## population genetics MOLECULAR ECOLOGY Poosakkannu, Anbu/J-4512-2019; Štefka,
    ## Jan/N-3924-2019; Martinu, Jana/AAE-4006-2021; Hypša, Václav/ABA-1503-2021
    ## Poosakkannu, Anbu/0000-0003-2579-150X; Štefka, Jan/0000-0002-1283-9730; Hypša,
    ## Václav/0000-0001-5572-782X; Martinu, Jana/0000-0003-02>>. If the fields are not
    ## quoted (e.g. field separator does not appear within any field), try quote="" to
    ## avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## out-of-sample. First healed line 969: <<J Liz, J Liz, Jordan "THE FIXITY OF
    ## WHITENESS" Genetic Admixture and the Legacy of the One-Drop Rule CRITICAL
    ## PHILOSOPHY OF RACE Liz, Jordan/0000-0001-8184-3306 2165-8684 2165-8692 2018
    ## 6 2 239 261 WOS:000439390700006>>. If the fields are not quoted (e.g. field
    ## separator does not appear within any field), try quote="" to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting out-
    ## of-sample. First healed line 111: <<J Blanquer, A; Uriz, MJ Blanquer, Andrea;
    ## Uriz, Maria-J "Living Together Apart": The Hidden Genetic Diversity of Sponge
    ## Populations MOLECULAR BIOLOGY AND EVOLUTION Uriz, Maria/J-9001-2012; Uriz,
    ## Maria J./AGP-4595-2022 Uriz, Maria J./0000-0002-8169-3173 0737-4038 1537-1719
    ## SEP 2011 28 9 2435 2438 10.1093/molbev/msr096 http://dx.doi.org/10.1093/molbev/
    ## msr096 21498599 WOS:000294552700004>>. If the fields are not quoted (e.g. field
    ## separator does not appear within any field), try quote="" to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## out-of-sample. First healed line 808: <<J Betz, T; Immel, UD; Kleiber, M;
    ## Klintschar, M Betz, Thomas; Immel, Uta-Dorothee; Kleiber, Manfred; Klintschar,
    ## Michael "Paterniplex", a highly discriminative decaplex STR multiplex tailored
    ## for investigating special problems in paternity testing ELECTROPHORESIS
    ## 0173-0835 1522-2683 NOV 2007 28 21 3868 3874 10.1002/elps.200700050 http://
    ## dx.doi.org/10.1002/elps.200700050 17960835 WOS:000251012200012>>. If the fields
    ## are not quoted (e.g. field separator does not appear within any field), try
    ## quote="" to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting out-
    ## of-sample. First healed line 392: <<J Hall, BK Hall, Brian K. "Evolutionist and
    ## missionary," the reverend John Thomas Gulick (1832-1923). Part 1: Cumulative
    ## segregation - Geographical isolation JOURNAL OF EXPERIMENTAL ZOOLOGY PART B-
    ## MOLECULAR AND DEVELOPMENTAL EVOLUTION 1552-5007 1552-5015 SEP 15 2006 306B 5
    ## 407 418 10.1002/jez.b.21107 http://dx.doi.org/10.1002/jez.b.21107 16703609 WOS:
    ## 000240582400001>>. If the fields are not quoted (e.g. field separator does not
    ## appear within any field), try quote="" to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting out-
    ## of-sample. First healed line 863: <<J Stasyuk, IV; Mustafin, KK; Alborova, IE
    ## Stasyuk, I., V; Mustafin, Kh Kh; Alborova, I. E. "Slavic Colonization" of the
    ## Vod' Land: historiography, problems, new approaches STRATUM PLUS Stasyk, Ivan/
    ## AAC-5906-2020 Stasyk, Ivan/0000-0003-2507-2572 1608-9057 1857-3533 2020 5 347
    ## 361 WOS:000589390000024>>. If the fields are not quoted (e.g. field separator
    ## does not appear within any field), try quote="" to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## in first 100 rows. If the fields are not quoted (e.g. field separator does not
    ## appear within any field), try quote="" to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting out-
    ## of-sample. First healed line 844: <<J Johansen, T; Westgaard, JI; Seliussen,
    ## BB; Nedreaas, K; Dahle, G; Glover, KA; Kvalsund, R; Aglen, A Johansen, Torild;
    ## Westgaard, Jon-Ivar; Seliussen, Bjorghild B.; Nedreaas, Kjell; Dahle, Geir;
    ## Glover, Kevin A.; Kvalsund, Roger; Aglen, Asgeir "Real-time" genetic monitoring
    ## of a commercial fishery on the doorstep of an MPA reveals unique insights into
    ## the interaction between coastal and migratory forms of the Atlantic cod ICES
    ## JOURNAL OF MARINE SCIENCE Breistein, Bjorghild>>. If the fields are not quoted
    ## (e.g. field separator does not appear within any field), try quote="" to avoid
    ## this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## out-of-sample. First healed line 254: <<J Mzilahowa, T; McCall, PJ; Hastings,
    ## IM Mzilahowa, Themba; McCall, Philip J.; Hastings, Ian M. "Sexual" Population
    ## Structure and Genetics of the Malaria Agent P. falciparum PLOS ONE Hastings,
    ## Ian/0000-0002-1332-742X; McCall, Philip/0000-0002-0007-3985 1932-6203 JUL
    ## 18 2007 2 7 e613 10.1371/journal.pone.0000613 http://dx.doi.org/10.1371/
    ## journal.pone.0000613 17637829 WOS:000207452100003>>. If the fields are not
    ## quoted (e.g. field separator does not appear within any field), try quote="" to
    ## avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## in first 100 rows. If the fields are not quoted (e.g. field separator does not
    ## appear within any field), try quote="" to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting out-
    ## of-sample. First healed line 319: <<J Razakandrainibe, FG; Durand, P; Koella,
    ## JC; De Meeus, T; Rousset, F; Ayala, FJ; Renaud, F Razakandrainibe, FG; Durand,
    ## P; Koella, JC; De Meeus, T; Rousset, F; Ayala, FJ; Renaud, F "Clonal" population
    ## structure of the malaria agent Plasmodium falciparum in high-infection regions
    ## PROCEEDINGS OF THE NATIONAL ACADEMY OF SCIENCES OF THE UNITED STATES OF
    ## AMERICA Rousset, Francois/C-7360-2008; Rousset, Francois/GRJ-3980-2022 Rousset,
    ## Francois/0000-0003-4670-0371; Rousset, Francoi>>. If the fields are not quoted
    ## (e.g. field separator does not appear within any field), try quote="" to avoid
    ## this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## out-of-sample. First healed line 363: <<J Stefan, LM; Gomez-Diaz, E; Mironov,
    ## SV; Gonzalez-Solis, J; McCoy, KD Stefan, Laura M.; Gomez-Diaz, Elena; Mironov,
    ## Sergey V.; Gonzalez-Solis, Jacob; McCoy, Karen D. "More Than Meets the Eye":
    ## Cryptic Diversity and Contrasting Patterns of Host-Specificity in Feather
    ## Mites Inhabiting Seabirds FRONTIERS IN ECOLOGY AND EVOLUTION Gonzalez-Solis,
    ## Jacob/C-3942-2008; Gonzalez-Solis, Jacob/AAZ-5338-2021; Gómez-Díaz, Elena/
    ## AAA-9141-2019; González-Solís, Jacob/AAB-1161-2019; McCo>>. If the fields are
    ## not quoted (e.g. field separator does not appear within any field), try quote=""
    ## to avoid this warning.

    ## Warning in fread(paste0("data/web_of_science/
    ## WoS_2020-10-18_population_genomics_", : Found and resolved improper quoting
    ## out-of-sample. First healed line 164: <<J Detroit, F; Corny, J; Dizon, EZ;
    ## Mijares, AS Detroit, Florent; Corny, Julien; Dizon, Eusebio Z.; Mijares, Armand
    ## S. "Small Size" in the Philippine Human Fossil Record: Is It Meaningful for a
    ## Better Understanding of the Evolutionary History of the Negritos? HUMAN BIOLOGY
    ## Détroit, Florent/G-1022-2010; Détroit, Florent/AFU-6586-2022 Détroit, Florent/
    ## 0000-0001-5208-6203; Détroit, Florent/0000-0001-5208-6203 0018-7143 1534-6617
    ## FEB-JUN 2013 85 1-3 SI 45 65>>. If the fields are not quoted (e.g. field
    ## separator does not appear within any field), try quote="" to avoid this warning.

``` r
# transform
sumgenetics <- wosgenetics[, .(npubs = .N, class = 'genetics'), by = PY]
sumgenomics <- wosgenomics[, .(npubs = .N, class = 'genomics'), by = PY]
sumall <- wosall[, .(npubs = .N, class = 'all'), by = PY]
sum <- rbind(sumgenetics, sumgenomics)
sum <- merge(sum, sumall[, .(PY, npubsall = npubs)])
sum[, fpubs := npubs/npubsall]
```

# Plot publication number

``` r
ggplot(sum, aes(PY, npubs, color = class, group = class)) +
    geom_line()
```

    ## Warning: Removed 2 row(s) containing missing values (geom_path).

![](wos_pub_frequencies_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

# Plot publication fraction

Y-axis is fraction of coral population genomics publications out of all
population genomics publications

``` r
ggplot(sum[class =='genomics'], aes(PY, fpubs, color = class, group = class)) +
    geom_line()
```

    ## Warning: Removed 1 row(s) containing missing values (geom_path).

![](wos_pub_frequencies_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->
