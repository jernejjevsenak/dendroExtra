# dendroLib: Library with nonlinear methods for analyzing dendroclimatological data 

dednroLib package implements novel dendroclimatological methods, primarly used by the Tree-ring reasearch community. Functions are meant to introduce nonlinear methods in dendroclimatological analysis. 
So far, the core function is daily_response, which finds the optimal sequence of days that are linearly or nonlinearly related to a tree-ring proxy records. 


## Short introduction

The core purpose of the dendroLib package is to introduce novel dendroclimatological methods to study linear and nonlinear relationship between daily climate data and tree-ring sequences. The core function is daily_response, which finds the optimal sequence of days that are linearly or nonlinearly related to a tree-ring proxy records.
To use daily_response function, two data frames are required, one with daily climate data, e.g. temperatures; and one with tree-ring proxy records. Example data is provided, so users can see, how data frames should be organized. The daily_response function calculates all possible values of a selected statistical measure between response variables and daily environmental data. Calculations are based on a moving window, which runs through daily environmental data and calculates moving averages. 

```
result1 <- daily_response(response = example_proxies, env_data = daily_temperatures_LJ, method = "lm", measure = "r.squared", lower_limit = 150, upper_limit = 155)
```
The return of this function is a list with three elements: @calculations, @method, @measure. The return is organized in a way, that can be used by three plotting functions: plot_extreme(), plot_specific() and plot_heatmap(). 
Function plot_extreme() graphs a line plot of a row with the highest calculated measure. It indicates the sequence of days, that are the most related to the response variable(s). With plot_specific(), measures with selected window width are plotted. Function plot_heatmap() is a visual representation of calculated values.

```
plot_extreme(result1, title = FALSE)
plot_specific(result1, window_width = 153, title = TRUE)
plot_heatmap(result1)
```

## Authors

* **Jernej Jevšenak**

