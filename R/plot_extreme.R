#' plot_extreme
#'
#' Graphs a lineplot of a row with the highest measure in a matrix, produced by
#' \code{\link{daily_response}} function.
#'
#' @param result_daily_response a list with three objects as produced by
#' daily_response function
#' @param title logical, if set to FALSE, no plot title is displayed
#'
#' @return A ggplot2 object containing the plot display
#' @export
#'
#' @examples
#'
#' data(daily_temperatures_LJ)
#' data(example_proxies)
#' Example1 <- daily_response(response = example_proxies,
#' env_data = daily_temperatures_LJ, method = "lm", measure = "r.squared",
#' fixed_width = 90, previous_year = TRUE)
#' plot_extreme(Example1)
#'
#' Example2 <- daily_response(response = example_proxies,
#' env_data = daily_temperatures_LJ, method = "brnn", measure = "adj.r.squared",
#' lower_limit = 50, upper_limit = 55, neurons = 1)
#' plot_extreme(Example2, title = FALSE)

plot_extreme <- function(result_daily_response, title = TRUE) {

  # Short description of the function. It
  # - extracts matrix (the frst object of a list)
  # - in case of method == "cor" (second object of a list), calculates the
  # highest minimum and maximum and compare its absolute values. If absolute
  # minimum is higher than maximum, we have to plot minimum correlations.
  # - query the information about windows width (row names of the matrix) and
  # starting day of the mighest (absolute) measure (column names of the matrix).
  # - draws a ggplot line plot.

  # A) Extracting a matrix from a list and converting it into a data frame
  result_daily_element1 <- data.frame(result_daily_response[[1]])

  # With the following chunk, overall_maximum and overall_minimum values of
  # result_daily_element1 matrix are calculated.
  overall_max <- max(result_daily_element1, na.rm = TRUE)
  overall_min <- min(result_daily_element1, na.rm = TRUE)

  # absolute vales of overall_maximum and overall_minimum are compared and
  # one of the following two if functions is used
    # There are unimportant warnings produced:
    # no non-missing arguments to max; returning -Inf
    # Based on the answer on the StackOverlow site:
    # https://stackoverflow.com/questions/24282550/no-non-missing-arguments-warning-when-using-min-or-max-in-reshape2
    # Those Warnings could be easily ignored
  if ((abs(overall_max) > abs(overall_min)) == TRUE) {

    # maximum value is located. Row indeces are needed to query information
    # about the window width used to calculate the maximum. Column name is
    # needed to query the starting day.
    max_result <- suppressWarnings(which.max(apply(result_daily_element1,
      MARGIN = 2, max, na.rm = TRUE)))
    plot.column <- max_result
    max_index <- which.max(result_daily_element1[, names(max_result)])
    row_index <- row.names(result_daily_element1)[max_index]
    temoporal_vector <- unlist(result_daily_element1[max_index, ])
    temoporal_vector <- temoporal_vector[!is.na(temoporal_vector)]
    temoporal_vector <- data.frame(temoporal_vector)
    correlation <- round(max(temoporal_vector), 3)
  }

  if ((abs(overall_max) < abs(overall_min)) == TRUE) {

    # minimum value is located. Row indeces are needed to query information
    # about the window width used to calculate the minimum. Column name is
    # needed to query the starting day.
    min_result <- suppressWarnings(which.min(apply(result_daily_element1,
      MARGIN = 2, min, na.rm = TRUE)))
    plot.column <- min_result
    min_index <- which.min(result_daily_element1[, names(min_result)])
    row_index <- row.names(result_daily_element1)[min_index]
    temoporal_vector <- unlist(result_daily_element1[min_index, ])
    temoporal_vector <- temoporal_vector[!is.na(temoporal_vector)]
    temoporal_vector <- data.frame(temoporal_vector)
    correlation <- round(min(temoporal_vector), 3)
  }


  # In case of previous_year == TRUE, we calculate the day of a year
  # (plot.column), considering 366 days of previous year.
  if (nrow(temoporal_vector) > 366 & plot.column > 366) {
    plot.column_extra <- plot.column %% 366
  } else {
    plot.column_extra <- plot.column
  }

  # The final plot is being created. The first part of a plot is the same,
  # the second part is different, depending on temporal.vector, plot.column,
  # method and measure string stored in result_daily_response. The second part
  # defines xlabs, xlabs and ggtitles.

  # The definition of theme
  journal_theme <- theme_bw() +
    theme(axis.text = element_text(size = 12, face = "bold"),
          axis.title = element_text(size = 16), text = element_text(size = 14))

  if (title == FALSE){
    journal_theme <- journal_theme +
      theme(plot.title = element_blank())
  }

  final_plot <- ggplot(temoporal_vector, aes(y = temoporal_vector,
    x = seq(1, length(temoporal_vector)))) + geom_line(lwd = 1.2) +
     geom_vline(xintercept = plot.column, col = "red") +
     scale_x_continuous(breaks = sort(c(seq(0, nrow(temoporal_vector), 50),
       plot.column), decreasing = FALSE),
       labels = sort(c(seq(0, nrow(temoporal_vector), 50), plot.column))) +
       annotate("label", label = as.character(correlation),
         y = correlation, x = plot.column + 15) +
    journal_theme

  if ((nrow(temoporal_vector) > 366) &&  (plot.column > 366) &&
      (result_daily_response [[2]] == "cor")) {
    final_plot <- final_plot +
      ggtitle(paste("The highest correlation coefficient is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",
        plot.column_extra, "of current year")) +
      xlab("Day of a Year  (Including Previous Year)") +
      ylab("Correlation Coefficient")
    }

  if ((nrow(temoporal_vector) > 366) &&  (plot.column < 366) &&
      (result_daily_response [[2]] == "cor")) {
    final_plot <- final_plot +
      ggtitle(paste("The highest correlation coefficient is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",
        plot.column_extra, "of previous year")) +
      xlab("Day of a Year  (Including Previous Year)") +
      ylab("Correlation Coefficient")
    }

  if ((nrow(temoporal_vector) < 366) &&
      (result_daily_response [[2]] == "cor")) {
    final_plot <- final_plot +
      ggtitle(paste("The highest correlation coefficient is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",  plot.column)) +
      xlab("Day of a Year") +
      ylab("Correlation Coefficient")
  }

  # plot for lm and brnn method; using r.squared
  if ((nrow(temoporal_vector) > 366) &&  (plot.column > 366) &&
      ((result_daily_response [[2]] == "lm") |
          (result_daily_response [[2]] == "brnn")) &&
      (result_daily_response [[3]] == "r.squared")) {
    final_plot <- final_plot +
      ggtitle(paste("The highest explained variance is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",
        plot.column_extra, "of current year")) +
      xlab("Day of a Year  (Including Previous Year)") +
      ylab("Explained Variance")
  }

  if ((nrow(temoporal_vector) > 366) && (plot.column < 366) &&
     (result_daily_response[[2]] == "lm" |
          result_daily_response[[2]] == "brnn") &&
      result_daily_response[[3]] == "r.squared") {
    final_plot <- final_plot +
      ggtitle(paste("The highest explained variance is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",
        plot.column_extra, "of previous year")) +
      xlab("Day of a Year  (Including Previous Year)") +
      ylab("Explained Variance")
  }

  if (nrow(temoporal_vector) < 366 &&
     (result_daily_response[[2]] == "lm" |
          result_daily_response[[2]] == "brnn") &&
      result_daily_response[[3]] == "r.squared") {
    final_plot <- final_plot +
      ggtitle(paste("The highest explained variance is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",  plot.column)) +
      xlab("Day of a Year") +
      ylab("Explained Variance")
  }

  # plot for lm and brnn method; using adj.r.squared
  if ((nrow(temoporal_vector) > 366) && (plot.column > 366) &&
     (result_daily_response[[2]] == "lm" |
          result_daily_response[[2]] == "brnn") &&
      (result_daily_response[[3]] == "adj.r.squared")) {
    final_plot <- final_plot +
      ggtitle(paste("The highest adjusted explained variance is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",
        plot.column_extra, "of current year")) +
      xlab("Day of a Year  (Including Previous Year)") +
      ylab("Adjusted Explained Variance")
  }

  if ((nrow(temoporal_vector) > 366) &&  (plot.column < 366) &&
      ((result_daily_response [[2]] == "lm" |
          result_daily_response [[2]] == "brnn")) &&
      (result_daily_response [[3]] == "adj.r.squared")) {
    final_plot <- final_plot +
      ggtitle(paste("The highest adjusted explained variance is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",
        plot.column_extra, "of previous year")) +
      xlab("Day of a Year  (Including Previous Year)") +
      ylab("Adjusted Explained Variance")
  }

  if ((nrow(temoporal_vector) < 366) &&
      (result_daily_response [[2]] == "lm" |
          result_daily_response [[2]] == "brnn") &&
      (result_daily_response [[3]] == "adj.r.squared")) {
    final_plot <- final_plot +
      ggtitle(paste("The highest adjusted explained variance is ",
        "calculated with window width of",
        as.numeric(row_index), "days, starting on day",  plot.column)) +
      xlab("Day of a Year") +
      ylab("Adjusted Explained Variance")
  }

  print(final_plot)
}
