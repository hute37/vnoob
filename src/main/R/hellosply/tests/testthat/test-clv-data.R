#
library(readr)
library(dplyr)
library(ggplot2)


library(gsl)

library(BTYD)
library(BTYDplus)



setup({
  1
})

teardown({
  1
})

pkg_install <- function() {

  ##
  # gsl prerequisites
  #

  # sudo apt-get install libgsl2  libgsl-dev gsl-bin  gsl-ref-html  gsl-ref-psdoc

}



test_that("can eval BTYDPlus model", {

  # Params(
  # 1,
  # 0.419167305
  # ,
  # 17.36728484,
  # 0.840583193,
  # 1.35516062,
  # 24,24,List(0.1, 0.25, 0.5, 0.85, 0.9))
  #
  # 0.419167305
  # 2.35516062
  # 2.195743813
  # 0.3736746718122296
  # Some(1.2367157099256048)
  #
  #
  # Some(CbsWithChurn
  #      (CbsStats
  #        (2014-12-06T00:00:00Z,
  #          2014-12-06T00:00:00Z,
  #          1,
  #          0.0,
  #          157.42857142857142,
  #          980.489769848816,
  #          980.489769848816,
  #          0.0),
  #        0.37982507532017734,
  #        0.6201749246798227
  #        ))
  #

  enable_gsl <- FALSE

  dropout_at_zero <- TRUE

  x <- 0
  t.x <- 0.0
  T.cal <- 157.42857142857142
  T.cal <- 157.4286
  T.star <- 104.28571428571429

  vavg <- 980.489769848816

  pChurn <- 0.6201749246798227

  k <- 1
  r <- 0.41916730555555555
  alpha <- 17.36728484
  a <- 0.840583193
  b <- 1.35516062


  x <- 0
  t.x <- 0.0
  T.cal <- 90.42857142857143
  T.star <- 104.28571428571429

  pChurn <- 0.43919027543679623

  k <- 4
  r <- 0.41916730555555555
  alpha <- 17.36728484
  a <- 0.840583193
  b <- 1.35516062


  params <- c(k,r,alpha,a,b)


  vavg <- 155.46

  if (round(a, 2) == 1)
    a <- a + 0.01  # P1 not defined for a=1, so we add slight noise in such rare cases

  if ((enable_gsl) && requireNamespace("gsl", quietly = TRUE)) {
    h2f1 <- gsl::hyperg_2F1
  } else {
    # custom R implementation of h2f1 taken from BTYD source code
    h2f1 <- function(a, b, c, z) {
      lenz <- length(z)
      j <- 0
      uj <- 1:lenz
      uj <- uj / uj
      y <- uj
      lteps <- 0
      while (lteps < lenz) {
        lasty <- y
        j <- j + 1
        uj <- uj * (a + j - 1) * (b + j - 1) / (c + j - 1) * z / j
        y <- y + uj
        lteps <- sum(y == lasty)
      }
      return(y)
    }
  }
  # approximate via expression for conditional expected transactions for BG/NBD
  # model, but adjust scale parameter by k
  G <- function(r, alpha, a, b) 1 - (alpha / (alpha + T.star)) ^ r * h2f1(r, b + 1, a + b, T.star / (alpha + T.star))
  P1 <- (a + b + x - 1 + ifelse(dropout_at_zero, 1, 0)) / (a - 1)
  P2 <- G(r + x, k * alpha + T.cal, a, b + x - 1 + ifelse(dropout_at_zero, 1, 0))
  #P3 <- xbgcnbd.PAlive(params = params, x = x, t.x = t.x, T.cal = T.cal, dropout_at_zero = dropout_at_zero)
  P3 <- 1.0 - pChurn
  exp <- P1 * P2 * P3
  exp

  vv <- exp * vavg
  vv

  # Adjust bias BG/NBD-based approximation by scaling via the Unconditional
  # Expectations (for wich we have exact expression). Only do so, if we can
  # safely assume that the full customer cohort is passed.
  do.bias.corr <- k > 1 && length(x) == length(t.x) && length(x) == length(T.cal) && length(x) >= 100
  if (do.bias.corr) {
    sum.cal <- sum(BTYDplus:::xbgcnbd.Expectation(params = params, t = T.cal, dropout_at_zero = dropout_at_zero))
    sum.tot <- sum(BTYDplus:::xbgcnbd.Expectation(params = params, t = T.cal + T.star, dropout_at_zero = dropout_at_zero))
    bias.corr <- (sum.tot - sum.cal) / sum(exp)
    exp <- exp * bias.corr
  }

  vv2 <- exp * vavg
  vv2

  ## ------------------------------------------------------------------------
  expect_true(TRUE)
})


Comment <- function(`@Comments`) {invisible()}

quantile_test_spark <- function() {
  # spark-shell
  Comment(`

          import org.apache.spark.sql._
          import org.apache.spark.sql.functions._
          import scala.io.Source
          import spark.implicits._

          val params_quantiles = Seq(0.1, 0.25, 0.5, 0.85, 0.9)
          val fn = "/home/developer/work/vn/vnoob/src/main/R/hellosply/data/clv_sample_orders.csv"

          val ds = Source.fromFile(fn)
          .getLines.drop(1).toList.map(_.split(",")).map(x => (x(0), x(3), x(2).toDouble))
          .toDS.cache
          ds.show

          val tst: Dataset[Double] = ds
          .filter(r => r._2 >= "2015-12-13" && r._2 < "2017-12-13")
          .groupBy("_1").agg(sum("_3").alias("s")).select("s").filter("s > 0").as[Double]

          println(tst.count)
          println(tst.groupBy(lit(1)).agg(sum("s")).collect.apply(0))

          val ttt = tst
          // val ttt = tst.union(tst).union(tst).union(tst).union(tst).union(tst).union(tst)
          //     .union(tst).union(tst).union(tst).union(tst).union(tst).union(tst)

          val q = ttt.stat.approxQuantile("s", params_quantiles.toArray, 0.0)

          println("\n\n\nQUANTILES => \n\n\n qk.approx <- "+(q.toList.toString).replaceAll("List\\(","c\\(")+" \n\n\n")


          val tempTable = s"tst_tst"
          ttt.createOrReplaceTempView(tempTable)
          //val str = para
          spark.sqlContext.sql("select percentile_approx(s, 0.9) from tst_tst").show
          spark.sqlContext.sql("select percentile(s, 0.9) from tst_tst").show
          spark.catalog.dropTempView(tempTable)


  `)

}


quantile_test <- function() {

  fn <- "data/clv_sample_orders.csv"


  clv_sample_orders <- read_csv(fn, col_types = cols(
    date = col_date(format = "%Y-%m-%d"),
    raw_date = col_date(format = "%Y-%m-%d")))

  #View(clv_sample_orders)

  dt.a <- as.Date('2015-12-13')
  dt.b <- as.Date('2017-12-13')

  clv_sales.z <- clv_sample_orders %>%
    filter((raw_date >= dt.a)) %>%
    filter((raw_date < dt.b)) %>%
    group_by(customer_id) %>%
    summarize(total=(sum(sales)))

  clv_sales <- clv_sales.z[clv_sales.z$total > 0,]

  norm_vec <- function(x) sqrt(sum(x^2))


  sale.min <- min(clv_sales$total)
  sale.max <- max(clv_sales$total)

  # spark approxQuantile => List(132.537313432836, 261.919559619995, 579.17, 2967.458968127149, 4316.64192111549)
  qk.approx <- c(132.537313432836, 261.919559619995, 579.17, 2967.458968127149, 4316.64192111549)
  qk <- c(sale.min, qk.approx, sale.max)
  qk



  qt <- c(1:9)
  qp <- c(0,0.1,0.25,0.5,0.85,0.9,1.0) # seq(0,1, by=0.25)

  qm <- matrix(nrow=length(qt), ncol=length(qp))

  for (t in qt) {
    qm[t,] <- quantile(clv_sales$total[clv_sales$total > 0], probs = qp, type = t)
  }

  qm

  qr <- matrix(nrow=length(qt), ncol=length(qp))
  qu <- matrix(nrow=length(qt), ncol=length(qp))
  qe <- 0.0
  for (t in qt) {
    qr[t,] <- qm[t,] - qk
    qu[t,] <- qr[t,]/qm[t,]*100.0
    qe[t] <- norm_vec(qr[t,])
  }
  qr
  qu
  qe
  qi.e <- which.min(qe)
  qi.e

  qk
  qm[qi.e,]
  qr[qi.e,]


  qs <- qm %*% qk

  qi.s <- which.max(qs)


  qi <- qi.e
  ql <- qm[qi,]
  qd <- qk -ql

  qd


  q <- qm[qi,]

  clv_sales$clazz <- cut(clv_sales$total, breaks=q,include.lowest=TRUE)
  summary(clv_sales$clazz)

  clv_sales$clazk <- cut(clv_sales$total, breaks=qk,include.lowest=TRUE)
  summary(clv_sales$clazk)

  clv_sales$clazd <- as.numeric(clv_sales$clazz) - as.numeric(clv_sales$clazk)
  summary(clv_sales$clazd)

  clv_diff <- clv_sales[ clv_sales$clazd != 0,]
  clv_diff

  clv_orders.a <- clv_sample_orders[clv_sample_orders$raw_date >= dt.a,]
  clv_orders.b <- clv_sample_orders[clv_sample_orders$raw_date < dt.b,]
  clv_orders.ab <- clv_sample_orders[(clv_sample_orders$raw_date < dt.b) & (clv_sample_orders$raw_date >= dt.a),]




}


zz.xbgcnbd.ConditionalExpectedTransactions <- function(params, T.star, x, t.x, T.cal, dropout_at_zero = NULL) {
  stopifnot(!is.null(dropout_at_zero))
  max.length <- max(length(T.star), length(x), length(t.x), length(T.cal))
  if (max.length %% length(T.star))
    warning("Maximum vector length not a multiple of the length of T.star")
  if (max.length %% length(x))
    warning("Maximum vector length not a multiple of the length of x")
  if (max.length %% length(t.x))
    warning("Maximum vector length not a multiple of the length of t.x")
  if (max.length %% length(T.cal))
    warning("Maximum vector length not a multiple of the length of T.cal")
  dc.check.model.params.safe(c("k", "r", "alpha", "a", "b"), params, "xbgcnbd.ConditionalExpectedTransactions")
  if (params[1] != floor(params[1]) | params[1] < 1)
    stop("k must be integer being greater or equal to 1.")
  if (any(T.star < 0) || !is.numeric(T.star))
    stop("T.star must be numeric and may not contain negative numbers.")
  if (any(x < 0) || !is.numeric(x))
    stop("x must be numeric and may not contain negative numbers.")
  if (any(t.x < 0) || !is.numeric(t.x))
    stop("t.x must be numeric and may not contain negative numbers.")
  if (any(T.cal < 0) || !is.numeric(T.cal))
    stop("T.cal must be numeric and may not contain negative numbers.")
  x <- rep(x, length.out = max.length)
  t.x <- rep(t.x, length.out = max.length)
  T.cal <- rep(T.cal, length.out = max.length)
  T.star <- rep(T.star, length.out = max.length)
  k <- params[1]
  r <- params[2]
  alpha <- params[3]
  a <- params[4]
  b <- params[5]
  if (round(a, 2) == 1)
    a <- a + 0.01  # P1 not defined for a=1, so we add slight noise in such rare cases
  if (requireNamespace("gsl", quietly = TRUE)) {
    h2f1 <- gsl::hyperg_2F1
  } else {
    # custom R implementation of h2f1 taken from BTYD source code
    h2f1 <- function(a, b, c, z) {
      lenz <- length(z)
      j <- 0
      uj <- 1:lenz
      uj <- uj / uj
      y <- uj
      lteps <- 0
      while (lteps < lenz) {
        lasty <- y
        j <- j + 1
        uj <- uj * (a + j - 1) * (b + j - 1) / (c + j - 1) * z / j
        y <- y + uj
        lteps <- sum(y == lasty)
      }
      return(y)
    }
  }
  # approximate via expression for conditional expected transactions for BG/NBD
  # model, but adjust scale parameter by k
  G <- function(r, alpha, a, b) 1 - (alpha / (alpha + T.star)) ^ r * h2f1(r, b + 1, a + b, T.star / (alpha + T.star))
  P1 <- (a + b + x - 1 + ifelse(dropout_at_zero, 1, 0)) / (a - 1)
  P2 <- G(r + x, k * alpha + T.cal, a, b + x - 1 + ifelse(dropout_at_zero, 1, 0))
  P3 <- xbgcnbd.PAlive(params = params, x = x, t.x = t.x, T.cal = T.cal, dropout_at_zero = dropout_at_zero)
  exp <- P1 * P2 * P3
  # Adjust bias BG/NBD-based approximation by scaling via the Unconditional
  # Expectations (for wich we have exact expression). Only do so, if we can
  # safely assume that the full customer cohort is passed.
  do.bias.corr <- k > 1 && length(x) == length(t.x) && length(x) == length(T.cal) && length(x) >= 100
  if (do.bias.corr) {
    sum.cal <- sum(xbgcnbd.Expectation(params = params, t = T.cal, dropout_at_zero = dropout_at_zero))
    sum.tot <- sum(xbgcnbd.Expectation(params = params, t = T.cal + T.star, dropout_at_zero = dropout_at_zero))
    bias.corr <- (sum.tot - sum.cal) / sum(exp)
    exp <- exp * bias.corr
  }
  return(unname(exp))
}




qnbinom_test <- function() {

  size <- 6
  prob <- 0.4

  p <- c(0:1000) / 1000.0


  q <- qnbinom(p, size, prob, lower.tail = TRUE, log.p = FALSE)

  df <-  data.frame(p,q)

  ggplot(data=df, aes(x=p, y=q, group=1)) +
    geom_line()+
    geom_point()



}



