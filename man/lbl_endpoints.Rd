% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/labels.R
\name{lbl_endpoints}
\alias{lbl_endpoints}
\alias{lbl_endpoint}
\title{Label chopped intervals by their left or right endpoints}
\usage{
lbl_endpoints(
  left = TRUE,
  fmt = NULL,
  single = NULL,
  first = NULL,
  last = NULL,
  raw = FALSE
)

lbl_endpoint(fmt = NULL, raw = FALSE, left = TRUE)
}
\arguments{
\item{left}{Flag. Use left endpoint or right endpoint?}

\item{fmt}{String, list or function. A format for break endpoints.}

\item{single}{Glue string: label for singleton intervals. See \code{\link[=lbl_glue]{lbl_glue()}}
for details.}

\item{first}{Glue string: override label for the first category. Write e.g.
\code{first = "<{r}"} to create a label like \code{"<18"}. See \code{\link[=lbl_glue]{lbl_glue()}}
for details.}

\item{last}{String: override label for the last category. Write e.g.
\code{last = ">{l}"} to create a label like \code{">65"}. See \code{\link[=lbl_glue]{lbl_glue()}}
for details.}

\item{raw}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}. Use the \code{raw} argument to \code{\link[=chop]{chop()}}
instead.}
}
\value{
A function that creates a vector of labels.
}
\description{
This is useful when the left endpoint unambiguously indicates the
interval. In other cases it may give errors due to duplicate labels.
}
\details{
\code{lbl_endpoint()} is \ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#defunct}{\figure{lifecycle-defunct.svg}{options: alt='[Defunct]'}}}{\strong{[Defunct]}} and gives an
error since santoku 1.0.0.
}
\section{Formatting endpoints}{


If \code{fmt} is not \code{NULL} then it is used to format the endpoints.
\itemize{
\item If \code{fmt} is a string, then numeric endpoints will be formatted by
\code{sprintf(fmt, breaks)}; other endpoints, e.g. \link{Date} objects, will be
formatted by \code{format(breaks, fmt)}.
\item If \code{fmt} is a list, then it will be used as arguments to \link{format}.
\item If \code{fmt} is a function, it should take a vector of numbers (or other objects
that can be used as breaks) and return a character vector. It may be helpful
to use functions from the \code{{scales}} package, e.g. \code{\link[scales:label_number]{scales::label_comma()}}.
}
}

\examples{
chop(1:10, c(2, 5, 8), lbl_endpoints(left = TRUE))
chop(1:10, c(2, 5, 8), lbl_endpoints(left = FALSE))
if (requireNamespace("lubridate")) {
  tab_width(
          as.Date("2000-01-01") + 0:365,
         months(1),
         labels = lbl_endpoints(fmt = "\%b")
       )
}

\dontrun{
  # This gives breaks `[1, 2) [2, 3) {3}` which lead to
  # duplicate labels `"2", "3", "3"`:
  chop(1:3, 1:3, lbl_endpoints(left = FALSE))
}
}
\seealso{
Other labelling functions: 
\code{\link{lbl_dash}()},
\code{\link{lbl_discrete}()},
\code{\link{lbl_glue}()},
\code{\link{lbl_intervals}()},
\code{\link{lbl_manual}()},
\code{\link{lbl_midpoints}()},
\code{\link{lbl_seq}()}
}
\concept{labelling functions}
