#' Print method for `optcheck` and `summary.optcheck` objects.
#'
#' @aliases print.summary.optcheck print.optproj print.summary.optproj print.optrefit print.summary.optrefit
#'
#' @template param_x
#' @param digits Number of digits to display.
#' @param n Number of elements of solution vector to display (see Details).
#' @param ... Further arguments to be passed to or from other methods.
#' @return Invisibly `x` itself.
#' @details The `print` methods for `optcheck` and `summary.optcheck` objects both display three-column matrix, consisting of the potential solution (`xsol`), the absolute difference between it and the optimal solution (`xopt`) return by either [optim_proj()] and [optim_refit()], and the relative difference (`R = (xopt - xsol)/|xsol|`).  Only the elemnts corresponding to the top-`n` relative differences are displayed.
#' @export
print.optcheck <- function(x, digits = max(3L, getOption("digits")-3L),
                           n = 5L, ...) {
  print(summary(x), digits = digits, n = n)
  invisible(x)
}

#' @rdname print.optcheck
#' @export
print.summary.optcheck <- function(x,
                                   digits = max(3L, getOption("digits")-3L),
                                   n = 5L, ...) {
  nx <- length(x$xsol)
  nmax <- min(nx, n)
  otype <- ifelse(x$maximize, "maximization", "minimization")
  ctype <- switch(class(x)[1],
                  summary.optproj = "\'optim_proj\'",
                  summary.optrefit = "\'optim_refit\'")
  cat("\n", ctype, " check on ", nx, "-variable ", otype, " problem.\n\n",
      "Top ", nmax, " relative errors in potential solution:\n\n",
      sep = "")
  res <- cbind(x$xsol, x$xdiff[,"abs"], x$xdiff[,"rel"])
  colnames(res) <- c("xsol", "D=xopt-xsol", "R=D/|xsol|")
  ord <- order(round(abs(res[,3]), 6), decreasing = TRUE)[1:nmax]
  print(signif(res[ord,], digits = digits))
  cat("\n")
  invisible(x)
}
