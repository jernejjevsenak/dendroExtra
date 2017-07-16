## Resubmission
This is a resubmission. CRAN devtools results returned the following error: Package required and available but unsuitable version: 'stats'. To remove the error:

* I changed the Depends field in the Description file: Depends: R (>= 3.4). I decided to do that since the error was produced in an earlier version of R (i.e. R 3.3.3 (2017-03-06)).
* I removed the specific version of 'stats' in the Imports field in the Description file. 
* I changed the import in the NAMESCPACE for 'stats'. Now: importFrom("stats", "cor", "lm", "qt", "quantile")

I have also changed the version of dendroExtra to 0.0.2

## Test environments
* local OS X install, R 3.4.0
* Ubuntu precise (12.04.5 LTS) (on travis-ci), R version 3.4.0 (2017-04-21)
* win-builder (R Under development (unstable) (2017-07-12 r72910))

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs


## Downstream dependencies
We have also run R CMD check on downstream dependencies of dendroExtra
https://github.com/jernejjevsenak/dendroExtra/blob/master/revdep/checks.rds

All packages that we could install passed. 
