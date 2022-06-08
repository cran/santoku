## ---- include = FALSE---------------------------------------------------------
set.seed(23479)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(santoku)
x <- runif(10, 0, 10)
(chopped <- chop(x, breaks = 0:10))
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chopped <- chop(x, breaks = 3:7)
data.frame(x, chopped)

## -----------------------------------------------------------------------------
x_fives <- x
x_fives[1:5] <- 5
chopped <- chop(x_fives, c(2, 5, 5, 8))
data.frame(x_fives, chopped)

## -----------------------------------------------------------------------------
tab(1:10, c(2, 5, 8))

## -----------------------------------------------------------------------------
chopped <- chop_width(x, 2)
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chopped <- chop_evenly(x, intervals = 3)
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chopped <- chop_n(x, 4)
table(chopped)

## -----------------------------------------------------------------------------
chopped <- chop_equally(x, groups = 5)
table(chopped)

## -----------------------------------------------------------------------------
chopped <- chop_quantiles(x, c(0.25, 0.5, 0.75))
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chopped <- chop_mean_sd(x)
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chopped <- chop_pretty(x)
data.frame(x, chopped)

## -----------------------------------------------------------------------------
tab_n(x, 4)
tab_width(x, 2)
tab_evenly(x, 5)
tab_mean_sd(x)

## -----------------------------------------------------------------------------
library(lubridate)
y2k <- as.Date("2000-01-01") + 0:365
months <- chop_width(y2k, months(1))
table(months)

## -----------------------------------------------------------------------------
chopped <- chop(x, c(2, 5, 8), labels = c("Lowest", "Low", "Higher", "Highest"))
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chopped <- chop(x, c(2, 5, 8), labels = lbl_dash())
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chopped  <- chop(1:10, c(2, 5, 8), labels = lbl_discrete())
chopped2 <- chop(1:10, c(2, 5, 8), labels = lbl_dash())
data.frame(x = 1:10, lbl_discrete = chopped, lbl_dash = chopped2)

## -----------------------------------------------------------------------------
chopped <- chop(x, c(2, 5, 8), labels = lbl_dash(first = "< 2", last = "8+"))
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chopped <- chop(x, c(2, 5, 8), labels = lbl_seq())
data.frame(x, chopped)

## -----------------------------------------------------------------------------
chop(x, c(2, 5, 8), labels = lbl_seq("(1)"))
chop(x, c(2, 5, 8), labels = lbl_seq("i."))

## -----------------------------------------------------------------------------
chopped <- chop(x, c(3, 5, 7), extend = FALSE)
data.frame(x, chopped)

## -----------------------------------------------------------------------------
y <- 1:5
data.frame(
        y = y, 
        left_closed = chop(y, 1:5), 
        right_closed = chop(y, 1:5, left = FALSE)
      )

## -----------------------------------------------------------------------------
data.frame(
  y = y,
  rightmost_open = chop(y, 1:5),
  rightmost_closed   = chop(y, 1:5, close_end = TRUE)
)


