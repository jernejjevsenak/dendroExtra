# dendroExtra 0.0.2.

** Functional Changes

* brnn function in the daily_response() is wrapped in try() function. This is the solution for error in extremly rare cases. See Stackoverflow discussion: https://stackoverflow.com/questions/45095176/system-is-computationally-singular-brnn-package
* a new function is introduced: years_to_rownames(). Function is meant to move column with years into rownames. 

** Technicla Changes

* I changed the Depends field in the Description file: Depends: R (>= 3.4). I decided to do that since the error was produced in an earlier version of R (i.e. R 3.3.3 (2017-03-06)).
* I removed the specific version of 'stats' in the Imports field in the Description file. 
* I changed the import in the NAMESCPACE for 'stats'. Now: importFrom("stats", "cor", "lm", "qt", "quantile")
