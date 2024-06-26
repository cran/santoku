
brackets <- function (x) paste0("(", x, ")")


test_that("lbl_manual and lbl_endpoint are defunct", {
  lifecycle::expect_defunct(lbl_manual(letters))
  lifecycle::expect_defunct(lbl_endpoint()(lbrk))
})


test_that("lbl_seq", {
  brk <- brk_res(brk_manual(1:3, rep(TRUE, 3)))

  expect_error(lbl_seq("b"))
  expect_error(lbl_seq("a1"))
  expect_error(lbl_seq(c("a", "b")))

  expect_equivalent(lbl_seq()(brk), c("a", "b"))
  expect_equivalent(lbl_seq("A")(brk), c("A", "B"))
  expect_equivalent(lbl_seq("i")(brk), c("i", "ii"))
  expect_equivalent(lbl_seq("I")(brk), c("I", "II"))
  expect_equivalent(lbl_seq("1")(brk), c("1", "2"))

  expect_equivalent(lbl_seq("(a)")(brk), c("(a)", "(b)"))
  expect_equivalent(lbl_seq("i.")(brk), c("i.", "ii."))
  expect_equivalent(lbl_seq("I:")(brk), c("I:", "II:"))
  expect_equivalent(lbl_seq("1)")(brk), c("1)", "2)"))

  brk_many <- brk_res(brk_manual(1:28, rep(TRUE, 28)))
  expect_error(lbl_seq("a")(brk_many))
  expect_error(lbl_seq("A)")(brk_many))
})


test_that("lbl_dash", {
  brk <- brk_res(brk_manual(1:3, rep(TRUE, 3)))
  em_dash <- em_dash()
  expect_equivalent(lbl_dash()(brk), paste0(1:2, em_dash, 2:3))
  expect_equivalent(lbl_dash("/")(brk), c("1/2", "2/3"))
})


test_that("lbl_dash arguments", {
  brk <- brk_res(brk_default(1:3), 1:2)
  expect_equivalent(lbl_dash("-", fmt = "%.2f")(brk), c("1.00-2.00", "2.00-3.00"))

  expect_equivalent(lbl_dash("-", first = "< 2")(brk), c("< 2", "2-3"))
  expect_equivalent(lbl_dash("-", last = "> 2")(brk), c("1-2", "> 2"))

  expect_equivalent(lbl_dash("-", first = "< {r}")(brk), c("< 2", "2-3"))
  expect_equivalent(lbl_dash("-", last = "> {l}")(brk), c("1-2", "> 2"))

  expect_equivalent(
    lbl_dash("-", fmt = brackets)(brk),
    c("(1)-(2)", "(2)-(3)")
  )

  expect_equivalent(
    lbl_dash("-", fmt = list(width = 2))(brk),
    c(" 1- 2", " 2- 3")
  )

  brk2 <- brk_res(brk_default(c(1, 2, 2, 3)), 1:2)
  expect_equivalent(
    lbl_dash("-", single = "Just {l}")(brk2),
    c("1-2", "Just 2", "2-3")
  )

  qbrk <- brk_res(brk_quantiles(c(0, .5, 1)), x = 0:10)
  expect_equivalent(lbl_dash("-")(qbrk), c("0%-50%", "50%-100%"))
  expect_equivalent(
    lbl_dash("-", fmt = "%.3f")(qbrk),
    c("0.000-0.500", "0.500-1.000")
  )


  lifecycle::expect_deprecated(lbl_dash(raw = TRUE))
  withr::local_options(lifecycle_verbosity = "quiet")

  expect_equivalent(lbl_dash("-", raw = TRUE)(qbrk), c("0-5", "5-10"))
  expect_equivalent(
    lbl_dash("-", raw = TRUE, fmt = "%.2f")(qbrk),
    c("0.00-5.00", "5.00-10.00")
  )
})


test_that("lbl_glue", {
  brk <- brk_res(brk_manual(1:3, rep(TRUE, 3)))
  expect_equivalent(
    lbl_glue("{l} to {r}")(brk),
    c("1 to 2", "2 to 3")
  )

  expect_equivalent(
    lbl_glue("{ifelse(l_closed, '[', '(')}{l},{r}{ifelse(r_closed, ']', ')')}")(brk),
    c("[1,2)", "[2,3)")
  )
})


test_that("lbl_glue arguments", {
  brk <- brk_res(brk_manual(1:3, rep(TRUE, 3)))
  expect_equivalent(
    lbl_glue("{l} to {r}", first = "Up to {r}", last = "Beyond {l}")(brk),
    c("Up to 2", "Beyond 2")
  )

  expect_equivalent(
    lbl_glue("<{l} to {r}>", fmt = "%.1f")(brk),
    c("<1.0 to 2.0>", "<2.0 to 3.0>")
  )

  expect_equivalent(
    lbl_glue("{l} to {r}", fmt = percent)(brk),
    c("100% to 200%", "200% to 300%")
  )

  expect_equivalent(
    lbl_glue("{l}/{r}", fmt = list(width = 2))(brk),
    c(" 1/ 2", " 2/ 3")
  )

  brk2 <- brk_res(brk_manual(c(1,2,2,3), c(TRUE, TRUE, FALSE, TRUE)))
  expect_equivalent(
    lbl_glue("{l} to {r}", single = "{{{l}}}")(brk2),
    c("1 to 2", "{2}", "2 to 3")
  )

  expect_equivalent(
    lbl_glue("<l> to <r>", single = "{<l>}", .open = "<", .close = ">")(brk2),
    c("1 to 2", "{2}", "2 to 3")
  )

  expect_equivalent(
    lbl_glue("{l} to {r}")(brk2),
    c("1 to 2", "2 to 2", "2 to 3")
  )

  expect_equivalent(
    lbl_glue("<{l} to {r}>", fmt = '%.1f', single = "|{sprintf('%.3f', as.numeric(l))}|")(brk2),
    c("<1.0 to 2.0>", "|2.000|", "<2.0 to 3.0>")
  )

  qbrk <- brk_res(brk_quantiles(c(0, .5, 1)), x = 0:10)

  lifecycle::expect_deprecated(lbl_glue("{l} / {r}", raw = TRUE))

  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equivalent(
    lbl_glue("{l} / {r}", raw = TRUE)(qbrk),
    c("0 / 5", "5 / 10")
  )
})



test_that("lbl_endpoints", {
  lbrk <- brk_res(brk_default(c(1, 3, 5)), extend = FALSE)
  expect_equivalent(
    lbl_endpoints()(lbrk),
    c("1", "3")
  )
  expect_equivalent(
    lbl_endpoints(left = FALSE)(lbrk),
    c("3", "5")
  )

  dates <- as.Date("2000-01-01") + c(3, 5)
  dbrk <- brk_res(brk_default(dates),
                  x = as.Date("2000-01-01") + 1:10)
  expect_equivalent(
    lbl_endpoints()(dbrk),
    as.character(dates[1])
  )
})


test_that("lbl_endpoints arguments", {
  lbrk <- brk_res(brk_default(c(1, 3, 5)), extend = FALSE)
  expect_equivalent(
    lbl_endpoints(fmt = "%.2f")(lbrk),
    c("1.00", "3.00")
  )
  expect_equivalent(
    lbl_endpoints(fmt = percent)(lbrk),
    c("100%", "300%")
  )
  expect_equivalent(
    lbl_endpoints(fmt = list(nsmall = 2, decimal.mark = ","))(lbrk),
    c("1,00", "3,00")
  )
})


test_that("lbl_midpoints", {
  lbrk <- brk_res(brk_manual(1:3, rep(TRUE, 3)))
  expect_equivalent(lbl_midpoints()(lbrk), c("1.5", "2.5"))


  dates <- as.Date("2000-01-01") + c(3, 5)
  dbrk <- brk_res(brk_default(dates),
                  x = as.Date("2000-01-01") + 1:10)
  expect_equivalent(
    lbl_endpoints()(dbrk),
    c("2000-01-04")
  )
})


test_that("lbl_midpoints arguments", {
  lbrk <- brk_res(brk_manual(1:3, rep(TRUE, 3)))
  expect_equivalent(lbl_midpoints(first = "{r}")(lbrk), c("2", "2.5"))
  expect_equivalent(lbl_midpoints(last = "{l}")(lbrk), c("1.5", "2"))

  sbrk <- brk_res(brk_manual(c(1, 2, 2, 3), c(TRUE, TRUE, FALSE, TRUE)))
  expect_equivalent(lbl_midpoints(single = "[{l}]")(sbrk), c("1.5", "[2]", "2.5"))

  qbrk <- brk_res(brk_quantiles(c(0, 0.5, 1)), x = 0:10)
  expect_equivalent(lbl_midpoints(fmt = percent)(qbrk), c("25%", "75%"))
  expect_equivalent(
    lbl_midpoints(fmt = list(decimal.mark = ","))(qbrk),
    c("0,25", "0,75")
  )

  lifecycle::expect_deprecated(lbl_midpoints(raw = TRUE))

  withr::local_options(lifecycle_verbosity = "quiet")
  expect_equivalent(lbl_midpoints(raw = TRUE)(qbrk), c("2.5", "7.5"))
})


test_that("lbl_intervals", {
  lbrk <- brk_res(brk_manual(1:3, rep(TRUE, 3)))
  rbrk <- brk_res(brk_manual(1:3, rep(FALSE, 3)))
  expect_equivalent(lbl_intervals()(lbrk), c("[1, 2)", "[2, 3)"))
  expect_equivalent(lbl_intervals()(rbrk), c("(1, 2]", "(2, 3]"))

  lbrk <- brk_res(brk_default(1:3), close_end = TRUE)
  expect_equivalent(lbl_intervals()(lbrk), c("[1, 2)", "[2, 3]"))
  rbrk <- brk_res(brk_default(1:3), close_end = TRUE, left = FALSE)
  expect_equivalent(lbl_intervals()(rbrk), c("[1, 2]", "(2, 3]"))

  sbrk <- brk_res(brk_default(c(1, 2, 2, 3)))
  expect_equivalent(lbl_intervals()(sbrk), c("[1, 2)", "{2}", "(2, 3)"))

  mbrk <- brk_res(brk_manual(1:4, c(FALSE, TRUE, FALSE, TRUE)))
  expect_equivalent(lbl_intervals()(mbrk), c("(1, 2)", "[2, 3]", "(3, 4)"))
})


test_that("lbl_intervals arguments", {
  lbrk <- brk_res(brk_default(c(1, 2, 2, 3) + 0.5))
  expect_equivalent(
    lbl_intervals(fmt = "%.2f")(lbrk),
    c("[1.50, 2.50)", "{2.50}",  "(2.50, 3.50)")
  )

  expect_equivalent(
    lbl_intervals(fmt = list(digits = 2))(lbrk),
    c("[1.5, 2.5)", "{2.5}",  "(2.5, 3.5)")
  )

  lbrk <- brk_res(brk_default(1:3 * 10000))
  expect_equivalent(
    lbl_intervals(fmt = "%2g")(lbrk),
    c("[10000, 20000)", "[20000, 30000)")
  )

  qbrk <- brk_res(brk_quantiles(c(0, 0.5, 1)), x = 0:10)
  expect_equivalent(
    lbl_intervals()(qbrk),
    c("[0%, 50%)", "[50%, 100%)")
  )

  expect_equivalent(
    lbl_intervals(fmt = "%.2f")(qbrk),
    c("[0.00, 0.50)", "[0.50, 1.00)")
  )
  expect_equivalent(
    lbl_intervals(fmt = percent)(qbrk),
    c("[0%, 50%)", "[50%, 100%)")
  )
  expect_equivalent(
    lbl_intervals(fmt = list(digits = 2))(qbrk),
    c("[0.0, 0.5)", "[0.5, 1.0)")
  )

  lbrk <- brk_res(brk_default(c(1, 2, 2, 3)))
  expect_equivalent(
    lbl_intervals(first = "< {r}")(lbrk),
    c("< 2", "{2}", "(2, 3)")
  )
  expect_equivalent(
    lbl_intervals(last = "> {l}")(lbrk),
    c("[1, 2)", "{2}", "> 2")
  )
  expect_equivalent(
    lbl_intervals(single = "[{l}]")(lbrk),
    c("[1, 2)", "[2]", "(2, 3)")
  )

  lifecycle::expect_deprecated(lbl_intervals(raw = TRUE))

  withr::local_options(lifecycle_verbosity = "quiet")

  expect_equivalent(
    lbl_intervals(raw = TRUE)(qbrk),
    c("[0, 5)", "[5, 10)")
  )
  expect_equivalent(
    lbl_intervals(raw = TRUE, fmt = "%.2f")(qbrk),
    c("[0.00, 5.00)", "[5.00, 10.00)")
  )
})


test_that("lbl_discrete", {
  lbrk <- brk_res(brk_manual(1:3, rep(TRUE, 3)))
  rbrk <- brk_res(brk_manual(1:3, rep(FALSE, 3)))

  expect_equivalent(lbl_discrete()(lbrk), c("1", "2"))
  expect_equivalent(lbl_discrete()(rbrk), c("2", "3"))

  lbrk2 <- brk_res(brk_manual(c(1, 3, 5), rep(TRUE, 3)))
  em_dash <- em_dash()
  expect_equivalent(lbl_discrete()(lbrk2), paste0(c(1, 3), em_dash, c(2, 4)))
  expect_equivalent(lbl_discrete(" to ")(lbrk2), c("1 to 2", "3 to 4"))

  lbrk3 <- brk_res(brk_default(c(1, 3, 3, 5)), close_end = TRUE)
  expect_equivalent(lbl_discrete("-")(lbrk3), c("1-2", "3", "4-5"))

  # break containing (1,2) which has no integer in it:
  open_brk <- brk_res(brk_manual(1:3, c(FALSE, TRUE, FALSE)))
  expect_warning(l <- lbl_discrete()(open_brk))
  expect_equivalent(l[1], "--")
})


test_that("lbl_discrete arguments", {
  lbrk <- brk_res(brk_default(c(1, 3, 5)))
  expect_equivalent(
    lbl_discrete("-", fmt = "(%s)")(lbrk),
    c("(1)-(2)", "(3)-(4)")
  )

  expect_equivalent(
    lbl_discrete("-", fmt = brackets)(lbrk),
    c("(1)-(2)", "(3)-(4)")
  )

  expect_equivalent(
    lbl_discrete("-", fmt = list(nsmall = 1))(lbrk),
    c("1.0-2.0", "3.0-4.0")
  )

  expect_equivalent(
    lbl_discrete("-", first = "<= {r}")(lbrk),
    c("<= 2", "3-4")
  )

  expect_equivalent(
    lbl_discrete("-", last = ">= {l}")(lbrk),
    c("1-2", ">= 3")
  )

  sbrk <- brk_res(brk_default(c(1, 3, 3, 6)))
  expect_equivalent(
    lbl_discrete("-", single = "[{l}]")(sbrk),
    c("1-2", "[3]", "4-5")
  )

  brk1000 <- brk_res(brk_default(c(1, 3, 5) * 1000))
  expect_equivalent(
    lbl_discrete("-", unit = 1000)(brk1000),
    c("1000-2000", "3000-4000")
  )
})


test_that("bug: breaks labels don't produce duplicates", {
  brk <- brk_res(brk_default(c(1.333333335, 1.333333336, 1.333333337, 5)))
  lbls <- lbl_intervals()(brk)
  expect_equivalent(anyDuplicated(lbls), 0)
  lbls <- lbl_dash()(brk)
  expect_equivalent(anyDuplicated(lbls), 0)

  brk <- brk_res(brk_quantiles(seq(0, 1, 0.0001)), x = rnorm(10000))
  lbls <- lbl_intervals()(brk)
  expect_equivalent(anyDuplicated(lbls), 0)
  lbls <- lbl_dash()(brk)
  expect_equivalent(anyDuplicated(lbls), 0)
})


test_that("bug: lbl_endpoints() works with no format and non-standard breaks", {
  expect_error(
    chop_quantiles(0:10, 0.5, labels = lbl_endpoints())
    , NA)
  expect_error(
    chop_mean_sd(0:10, labels = lbl_endpoints())
    , NA)
})
