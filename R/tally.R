#' Counts/tally observations by group.
#'
#' `tally()` is a convenient wrapper for summarise that will either call
#' [n()] or \code{\link{sum}(n)} depending on whether you're tallying
#' for the first time, or re-tallying. `count()` is similar, but also
#' does the [group_by()] for you.
#'
#' @param x a [tbl()] to tally/count.
#' @param ...,vars Variables to group by.
#' @param wt (Optional) If omitted, will count the number of rows. If specified,
#'   will perform a "weighted" tally by summing the (non-missing) values of
#'   variable `wt`.
#' @param sort if `TRUE` will sort output in descending order of `n`
#' @return A tbl, grouped the same way as `x`.
#' @export
#' @examples
#' if (require("Lahman")) {
#' batting_tbl <- tbl_df(Batting)
#' tally(group_by(batting_tbl, yearID))
#' tally(group_by(batting_tbl, yearID), sort = TRUE)
#'
#' # Multiple tallys progressively roll up the groups
#' plays_by_year <- tally(group_by(batting_tbl, playerID, stint), sort = TRUE)
#' tally(plays_by_year, sort = TRUE)
#' tally(tally(plays_by_year))
#'
#' # This looks a little nicer if you use the infix %>% operator
#' batting_tbl %>% group_by(playerID) %>% tally(sort = TRUE)
#'
#' # count is even more succinct - it also does the grouping for you
#' batting_tbl %>% count(playerID)
#' batting_tbl %>% count(playerID, wt = G)
#' batting_tbl %>% count(playerID, wt = G, sort = TRUE)
#' }
#'
#' @note
#' The column name in the returned data is `n`, however if the data already
#' has a column named `n` a lower-case n will be appended and the column name
#' returned will be `nn`.  Likewise, if the table already has columns named `n`
#' and `nn` then the column returned will be `nnn`, etc.
tally <- function(x, wt, sort = FALSE) {
  if (missing(wt)) {
    if ("n" %in% names(x)) {
      message("Using n as weighting variable")
      wt <- quote(n)
    } else {
      wt <- NULL
    }
  } else {
    wt <- substitute(wt)
  }

  tally_(x, wt, sort = sort)
}

tally_ <- function(x, wt, sort = FALSE) {
  if (is.null(wt)) {
    n <- quote(n())
  } else {
    n <- lazyeval::interp(quote(sum(wt, na.rm = TRUE)), wt = wt)
  }

  n_name <- n_name(tbl_vars(x))
  out <- summarise_(x, .dots = setNames(list(n), n_name))

  if (!sort) {
    out
  } else {
    desc_n <- lazyeval::interp(quote(desc(n)), n = as.name(n_name))
    arrange_(out, desc_n)
  }
}

n_name <- function(x) {
  name <- "n"
  while (name %in% x) {
    name <- paste0(name, "n")
  }

  name

}

#' @export
#' @rdname tally
count <- function(x, ..., wt = NULL, sort = FALSE) {
  vars <- lazyeval::lazy_dots(...)
  wt <- substitute(wt)

  count_(x, vars, wt, sort = sort)
}

#' @export
#' @rdname tally
count_ <- function(x, vars, wt = NULL, sort = FALSE) {
  groups <- group_vars(x)

  x <- group_by_(x, .dots = vars, add = TRUE)
  x <- tally_(x, wt = wt, sort = sort)
  x <- group_by_(x, .dots = groups, add = TRUE)
  x
}
