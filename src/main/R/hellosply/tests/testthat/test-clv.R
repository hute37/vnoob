context("https://github.com/cran/BTYD/blob/master/inst/doc/BTYD-walkthrough.R")

library(sparklyr)
library(dplyr)

library(DBI)
library(BTYD)


setup({

  # Sys.setenv(SPARK_HOME = "/usr/hdp/current/spark2-client/")
  # Sys.setenv(HADOOP_CONF_DIR = '/etc/hadoop/conf.cloudera.hdfs')
  # Sys.setenv(YARN_CONF_DIR = '/etc/hadoop/conf.cloudera.yarn')

  Sys.getenv("SPARK_HOME")
  spark_default_vers <- '2.0.0.2.5.0.0'

  config <- spark_config()
  config$spark.executor.instances <- 2
  config$spark.executor.cores <- 2
  config$spark.executor.memory <- "1G"

  sc <<- spark_connect(master="yarn-client", config=config, version = '2.0.0.2.5.0.0')
  #sc <<- spark_connect(master = "local")

})

teardown({
  spark_disconnect(sc)
})



test_that("can load BTYD sample data", {


  ## ----message=FALSE, tidy=FALSE-------------------------------------------
  cdnowElog <- system.file("data/cdnowElog.csv", package = "BTYD")
  elog <- dc.ReadLines(cdnowElog, cust.idx = 2,
                       date.idx = 3, sales.idx = 5)
  elog[1:3,]

  ## ----message=FALSE-------------------------------------------------------
  elog$date <- as.Date(elog$date, "%Y%m%d");
  elog[1:3,]

  ## ----results="hide", message=FALSE---------------------------------------
  elog <- dc.MergeTransactionsOnSameDate(elog);

  ## ----message=FALSE-------------------------------------------------------
  end.of.cal.period <- as.Date("1997-09-30")
  elog.cal <- elog[which(elog$date <= end.of.cal.period), ]

  ## ----results="hide", message=FALSE---------------------------------------
  split.data <- dc.SplitUpElogForRepeatTrans(elog.cal);
  clean.elog <- split.data$repeat.trans.elog;

  ## ----message=FALSE-------------------------------------------------------
  freq.cbt <- dc.CreateFreqCBT(clean.elog);
  freq.cbt[1:3,1:5]

  ## ----results="hide", message=FALSE---------------------------------------
  tot.cbt <- dc.CreateFreqCBT(elog)
  cal.cbt <- dc.MergeCustomers(tot.cbt, freq.cbt)

  ## ----tidy=FALSE, results="hide", message=FALSE---------------------------
  birth.periods <- split.data$cust.data$birth.per
  last.dates <- split.data$cust.data$last.date
  cal.cbs.dates <- data.frame(birth.periods, last.dates,
                              end.of.cal.period)
  cal.cbs <- dc.BuildCBSFromCBTAndDates(cal.cbt, cal.cbs.dates,
                                        per="week")

  ## ------------------------------------------------------------------------
  params <- pnbd.EstimateParameters(cal.cbs);
  params
  LL <- pnbd.cbs.LL(params, cal.cbs);
  LL

  ## ------------------------------------------------------------------------
  p.matrix <- c(params, LL);
  for (i in 1:2){
    params <- pnbd.EstimateParameters(cal.cbs, params);
    LL <- pnbd.cbs.LL(params, cal.cbs);
    p.matrix.row <- c(params, LL);
    p.matrix <- rbind(p.matrix, p.matrix.row);
  }
  colnames(p.matrix) <- c("r", "alpha", "s", "beta", "LL");
  rownames(p.matrix) <- 1:3;
  p.matrix;

  ## ----fig.path="figure/", label="pnbdTransactionHeterogeneity", results="hide", include=FALSE----
  pnbd.PlotTransactionRateHeterogeneity(params);

  ## ----fig.path="figure/", label="pnbdDropoutHeterogeneity", results="hide", include=FALSE----
  pnbd.PlotDropoutRateHeterogeneity(params);

  ## ------------------------------------------------------------------------
  pnbd.Expectation(params, t=52);

  expect_true(TRUE)
})


test_that("spark_apply works in distributed mode", {

  return

  riris_tbl <- spark_apply(iris_tbl, function(data) {
    data[1:4] + rgamma(1,2)
  })

  riris <- riris_tbl %>% collect


  expect_true(TRUE)
})

