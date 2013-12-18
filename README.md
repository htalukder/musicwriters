musicwriters
============

Analysis of network of writers in the music industry over the last forty years. We look at the writers of songs that made it to the number 1 spot in the billboard hot 100 chart released weekly. Here we made networks of these writers yearly where nodes represent writers and edges represent a collaboration on a hit song. 

To install and run the app locally first install the `devtools` package if necessary (`install.packages("devtools")`) and run:

```
devtools::install_github("musicwriters", "htalukder")
```


Statistics Used:

1. Average Degree: The average number of collaborations by a writer within a given year.

2. Clustering Coefficient: Measures clustering tendency of network. Scale of 0 to 1 where 1 represents highly clustered network and 0 indicates no clusters. 

3. Largest Strongly Connected Component: Largest component of the full network where edges exist between any two nodes.

4. Network Density: Number of observed edges divided by the number of possible edges. 


Analysis done by Hisham Talukder: htalukde@math.umd.edu

Advisor: Hector Corrada Bravo Email: hcorrada@gmail.com

Spotify Data Collected with the help of Lee Mendelowitz: lmendy@gmail.com
