% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/labels.R
\name{lbl_dash}
\alias{lbl_dash}
\title{Label chopped intervals like 1 - 3, 4 - 5, ...}
\usage{
lbl_dash(symbol = " - ", raw = FALSE, fmt = NULL)
}
\arguments{
\item{symbol}{String: symbol to use for the dash.}

\item{raw}{Logical. Always use raw \code{breaks} in labels, rather than e.g. quantiles
or standard deviations?}

\item{fmt}{A format. Can be a string, passed into \code{\link[base:sprintf]{base::sprintf()}} or \code{\link[=format]{format()}}
methods; or a one-argument formatting function.}
}
\value{
A vector of labels for \code{chop}, or a function that creates labels.
}
\description{
This label style is user-friendly, but doesn't distinguish between
left- and right-closed intervals.
}
\examples{
chop(1:10, c(2, 5, 8), lbl_dash())

chop(1:10, c(2, 5, 8), lbl_dash(" to ", fmt = "\%.1f"))

pretty <- function (x) prettyNum(x, big.mark = ",", digits = 1)
chop(runif(10) * 10000, c(3000, 7000), lbl_dash(" to ", fmt = pretty))
}
\seealso{
Other labelling functions: 
\code{\link{lbl_discrete}()},
\code{\link{lbl_format}()},
\code{\link{lbl_intervals}()},
\code{\link{lbl_manual}()},
\code{\link{lbl_seq}()}
}
\concept{labelling functions}
