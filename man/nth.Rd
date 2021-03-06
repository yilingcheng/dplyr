% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nth-value.R
\name{nth}
\alias{nth}
\alias{first}
\alias{last}
\title{Extract the first, last or nth value from a vector.}
\usage{
nth(x, n, order_by = NULL, default = default_missing(x))

first(x, order_by = NULL, default = default_missing(x))

last(x, order_by = NULL, default = default_missing(x))
}
\arguments{
\item{x}{A vector}

\item{n}{For \code{nth_value()}, a single integer specifying the position.
Negative integers index from the end (i.e. \code{-1L} will return the
last value in the vector).

If a double is supplied, it will be silently truncated.}

\item{order_by}{An optional vector used to determine the order}

\item{default}{A default value to use if the position does not exist in
the input. This is guessed by default for base vectors, where a
missing value of the appropriate type is returned, and for lists, where
a \code{NULL} is return.

For more complicated objects, you'll need to supply this value.
Make sure it is the same type as \code{x}.}
}
\value{
A single value. \code{[[} is used to do the subsetting.
}
\description{
These are straightforward wrappers around \code{\link{[[}}. The main
advantage is that you can provide an optional secondary vector that defines
the ordering, and provide a default value to use when the input is shorter
than expected.
}
\examples{
x <- 1:10
y <- 10:1

nth(x, 1)
nth(x, 5)
nth(x, -2)
nth(x, 11)

last(x)
last(x, y)
}
