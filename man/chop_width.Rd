% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chop.R, R/breaks.R
\name{chop_width}
\alias{chop_width}
\alias{chop_evenly}
\alias{brk_width}
\alias{brk_width.default}
\alias{brk_evenly}
\title{Chop into equal-width intervals}
\usage{
chop_width(x, width, start, ..., left = width > 0)

chop_evenly(x, intervals, ..., groups, close_end = TRUE)

brk_width(width, start)

\method{brk_width}{default}(width, start)

brk_evenly(intervals)
}
\arguments{
\item{x}{A numeric vector.}

\item{width}{Width of intervals.}

\item{start}{Leftpoint of first interval. By default the smallest finite \code{x},
or if \code{width} is negative, the largest finite \code{x}.}

\item{...}{Passed to \code{\link[=chop]{chop()}}.}

\item{left}{Passed to \code{\link[=chop]{chop()}}.}

\item{intervals}{Integer: number of intervals to create.}

\item{groups}{Do not use. \lifecycle{deprecated}}

\item{close_end}{Passed to \code{\link[=chop]{chop()}}.}
}
\value{
For  \verb{chop_*} functions, a factor of the same length as \code{x}.
}
\description{
\code{chop_width()} chops \code{x} into intervals of width \code{width}. \code{chop_evenly}
chops \code{x} into \code{intervals} intervals of equal width.
}
\details{
If \code{width} is negative, intervals will go downwards from \code{start}.

\code{chop_evenly} sets \code{close_end = TRUE} by default. \code{chop_width} sets
\code{left = FALSE} if width is negative.
}
\examples{
chop_width(1:10, 2)

chop_width(1:10, 2, start = 0)

chop_width(1:9, -2)

chop(1:10, brk_width(2, 0))

chop_evenly(0:10, 5)

}
\seealso{
\link{brk_width-for-datetime}

Other chopping functions: 
\code{\link{chop_mean_sd}()},
\code{\link{chop_n}()},
\code{\link{chop_quantiles}()},
\code{\link{chop}()},
\code{\link{fillet}()}
}
\concept{chopping functions}
