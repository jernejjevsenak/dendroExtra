## Resubmission
This is a resubmission. In this version I have:

* Excluded all extensive examples, which returned NOTE in the win-builder testing environment. 
  To exclude examples \dontrun{...} was used. Before excluding examples, I tried to simplyfy 
  them to run more quickly, but even the simpliest examples exceeded allowed computational time. 

## Test environments
* local OS X install, R 3.4.0
* Ubuntu precise (12.04.5 LTS) (on travis-ci), R version 3.4.0 (2017-04-21)
* win-builder (R Under development (unstable) (2017-07-12 r72910))

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs


## Downstream dependencies
We have also run R CMD check on downstream dependencies of dplR
https://github.com/jernejjevsenak/dendroExtra/blob/master/revdep/checks.rds

All packages that we could install passed. 
