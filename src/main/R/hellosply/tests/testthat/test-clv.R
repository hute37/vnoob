context("https://github.com/cran/BTYD/blob/master/inst/doc/BTYD-walkthrough.R")

library(sparklyr)
library(dplyr)

library(DBI)
library(BTYD)

library(ggplot2)

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
  #  sc <<- spark_connect(master = "local")

})

teardown({
  spark_disconnect(sc)
})



test_that("can eval BTYD model, distributed in spark with sparklyr", {


  ## ----message=FALSE, tidy=FALSE-------------------------------------------
  cdnowElog <- system.file("data/cdnowElog.csv", package = "BTYD")
  elog <- dc.ReadLines(cdnowElog, cust.idx = 2,
                       date.idx = 3, sales.idx = 5)
  elog$date <- as.Date(elog$date, "%Y%m%d");
  elog <- dc.MergeTransactionsOnSameDate(elog);
  end.of.cal.period <- as.Date("1997-09-30")
  elog.cal <- elog[which(elog$date <= end.of.cal.period), ]
  split.data <- dc.SplitUpElogForRepeatTrans(elog.cal);
  clean.elog <- split.data$repeat.trans.elog;
  freq.cbt <- dc.CreateFreqCBT(clean.elog);
  tot.cbt <- dc.CreateFreqCBT(elog)
  cal.cbt <- dc.MergeCustomers(tot.cbt, freq.cbt)
  birth.periods <- split.data$cust.data$birth.per
  last.dates <- split.data$cust.data$last.date
  cal.cbs.dates <- data.frame(birth.periods, last.dates,
                              end.of.cal.period)
  cal.cbs <- dc.BuildCBSFromCBTAndDates(cal.cbt, cal.cbs.dates,
                                        per="week")

  ## ------------------------------------------------------------------------
  params <- pnbd.EstimateParameters(cal.cbs);
  names(params) <- c("r", "alpha", "s", "beta");
  params

  ## ------------------------------------------------------------------------
  # LL <- pnbd.cbs.LL(params, cal.cbs);
  # LL
  # p.matrix <- c(params, LL);
  # for (i in 1:2){
  #   params <- pnbd.EstimateParameters(cal.cbs, params);
  #   LL <- pnbd.cbs.LL(params, cal.cbs);
  #   p.matrix.row <- c(params, LL);
  #   p.matrix <- rbind(p.matrix, p.matrix.row);
  # }
  # colnames(p.matrix) <- c("r", "alpha", "s", "beta", "LL");
  # rownames(p.matrix) <- 1:3;
  # p.matrix;

  ## ----tidy=FALSE----------------------------------------------------------

  cal.cbs.df <- tibble::rownames_to_column(data.frame(cal.cbs),"cust")
  colnames(cal.cbs.df) <- c("cust", "x", "t_x", "T_cal")

  cal.cbs.df.est <- cal.cbs.df %>%
    mutate(
      est.CET = pnbd.ConditionalExpectedTransactions(params, T.star = 52,
                                                     x, t_x, T_cal),
      est.PAL = pnbd.PAlive(params, x, t_x, T_cal)
    )

  str(cal.cbs.df.est)
  head(cal.cbs.df.est)


  ## ----tidy=FALSE----------------------------------------------------------

  cbs_tbl <- copy_to(sc, cal.cbs.df, "cbs", overwrite = TRUE)
  src_tbls(sc)

  clv_tbl <- spark_apply(cbs_tbl, function(df) {
    df
  })

  clv_tbl <- spark_apply(cbs_tbl, function(df) {
    data.frame(zzz=(df$x + df$t_x + df$T_cal))
  })

  clv_tbl <- spark_apply(cbs_tbl, function(df) {
    df$est.CET <- BTYD::pnbd.ConditionalExpectedTransactions(params, T.star = 52, df$x, df$t_x, df$T_cal)
    df$est.PAL <- BTYD::pnbd.PAlive(params, df$x, df$t_x, df$T_cal)
  })

  clv_tbl <- spark_apply(cbs_tbl, function(df) {
      dplyr::mutate(df,
        est.CET = BTYD::pnbd.ConditionalExpectedTransactions(params, T.star = 52,
                                                       x, t_x, T_cal),
        est.PAL = BTYD::pnbd.PAlive(params, x, t_x, T_cal)
      )
  })

  clv.df <- clv_tbl %>% collect

  str(clv.df)
  head(clv.df)



  ## ------------------------------------------------------------------------
  expect_true(TRUE)
})





test_that("can run BTYD vignette: https://github.com/cran/BTYD/blob/master/inst/doc/BTYD-walkthrough.R", {


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

  ## ----tidy=FALSE----------------------------------------------------------
  cal.cbs["1516",]
  x <- cal.cbs["1516", "x"]
  t.x <- cal.cbs["1516", "t.x"]
  T.cal <- cal.cbs["1516", "T.cal"]
  pnbd.ConditionalExpectedTransactions(params, T.star = 52,
                                       x, t.x, T.cal)
  pnbd.PAlive(params, x, t.x, T.cal)

  ## ----tidy=FALSE----------------------------------------------------------
  for (i in seq(10, 25, 5)){
    cond.expectation <- pnbd.ConditionalExpectedTransactions(
      params, T.star = 52, x = i,
      t.x = 20, T.cal = 39)
    cat ("x:",i,"\t Expectation:",cond.expectation, fill = TRUE)
  }

  ## ----results="hide", eval=FALSE------------------------------------------
  #  pnbd.PlotFrequencyInCalibration(params, cal.cbs, 7)

  ## ----message=FALSE-------------------------------------------------------
  elog <- dc.SplitUpElogForRepeatTrans(elog)$repeat.trans.elog;
  x.star <- rep(0, nrow(cal.cbs));
  cal.cbs <- cbind(cal.cbs, x.star);
  elog.custs <- elog$cust;
  for (i in 1:nrow(cal.cbs)){
    current.cust <- rownames(cal.cbs)[i]
    tot.cust.trans <- length(which(elog.custs == current.cust))
    cal.trans <- cal.cbs[i, "x"]
    cal.cbs[i, "x.star"] <-  tot.cust.trans - cal.trans
  }
  cal.cbs[1:3,]

  ## ----fig.path="figure/", label="pnbdCondExpComp", tidy=FALSE, echo=TRUE, size="small", fig=FALSE----
  T.star <- 39 # length of the holdout period
  censor <- 7  # This censor serves the same purpose described above
  x.star <- cal.cbs[,"x.star"]
  comp <- pnbd.PlotFreqVsConditionalExpectedFrequency(params, T.star,
                                                      cal.cbs, x.star, censor)
  rownames(comp) <- c("act", "exp", "bin")
  comp

  ## ------------------------------------------------------------------------
  tot.cbt <- dc.CreateFreqCBT(elog)
  d.track.data <- rep(0, 7 * 78)
  origin <- as.Date("1997-01-01")
  for (i in colnames(tot.cbt)){
    date.index <- difftime(as.Date(i), origin) + 1;
    d.track.data[date.index] <- sum(tot.cbt[,i]);
  }
  w.track.data <-  rep(0, 78)
  for (j in 1:78){
    w.track.data[j] <- sum(d.track.data[(j*7-6):(j*7)])
  }

  ## ----fig.path="figure/", label="pnbdTrackingInc", tidy=FALSE, echo=TRUE, fig=FALSE----
  T.cal <- cal.cbs[,"T.cal"]
  T.tot <- 78
  n.periods.final <- 78
  inc.tracking <- pnbd.PlotTrackingInc(params, T.cal,
                                       T.tot, w.track.data,
                                       n.periods.final)
  inc.tracking[,20:25]

  ## ----fig.path="figure/", label="pnbdTrackingCum", tidy=FALSE, echo=TRUE, fig=FALSE----
  cum.tracking.data <- cumsum(w.track.data)
  cum.tracking <- pnbd.PlotTrackingCum(params, T.cal,
                                       T.tot, cum.tracking.data,
                                       n.periods.final)
  cum.tracking[,20:25]

  ## ------------------------------------------------------------------------
  expect_true(TRUE)
})






test_that("can run BTYD example: https://gist.github.com/mattbaggott/5113177", {


  #
  # PREDICTING LONG TERM CUSTOMER VALUE WITH BTYD PACKAGE
  # Pareto/NBD (negative binomial distribution) modeling of
  # repeat-buying behavior in a noncontractual setting
  #
  # Matthew Baggott, matt@baggott.net
  #
  # Accompanying slides at:
  # http://www.slideshare.net/mattbagg/baggott-predict-customerinrpart1#
  #
  # Based on Schmittlein, Morrison, and Colombo (1987), “Counting Your Customers:
  # Who Are They and What Will They Do Next?” Management Science, 33, 1–24.
  #
  # Required data for model is :
  #
  # "customer-by-sufficient-statistic” (cbs) matrix
  #               with the 'sufficient' stats being:
  #                       frequency of transaction
  #                       recency (time of last transaction) and
  #                       total time observed

  # Main model params are :

  # beta       unobserved shape parameter for dropout process
  # s          unobserved scale parameter for dropout process
  # r          unobserved shape parameter for NBD transaction
  # alpha      unobserved scale parameter for NBD transaction

  # Data are divided into earlier calibration and later holdout segments,
  # using a single date as the cut point.  "cal" data are used
  # to predict "holdout" data
  #
  ############################################


  # ############################################
  # #
  # # INSTALL AND LOAD NEEDED PACKAGES
  # #
  # ############################################
  #
  # # toInstallCandidates <- c("ggplot2", "BTYD", "reshape2", "plyr", "lubridate")
  # # # check if pkgs are already present
  # # toInstall <- toInstallCandidates[!toInstallCandidates%in%library()$results[,1]]
  # # if(length(toInstall)!=0)
  # # {install.packages(toInstall, repos = "http://cran.r-project.org")}
  # # # load pkgs
  # # lapply(toInstallCandidates, library, character.only = TRUE)
  # #
  #
  #
  # ############################################
  # #
  # # LOAD DATA
  # #
  # ############################################
  #
  #
  # # Data are 10% of the cohort of customers who made their first transactions
  # # with online retailer CDNOW (founded 1994) in the first quarter of 1997.
  #
  #
  # cdnowElog <- system.file("data/cdnowElog.csv", package = "BTYD")
  #
  # elog=read.csv(cdnowElog)                # read data
  # head(elog)                              # take a look
  # elog<-elog[,c(2,3,5)]                   # we need these columns
  # names(elog) <- c("cust","date","sales") # model functions expect these names
  #
  # # format date
  # elog$date <- as.Date(as.character(elog$date), format="%Y%m%d")
  #
  #
  # # Transaction-flow models, such as the Pareto/NBD, are concerned
  # # with interpurchase intervals.
  # # Since we only have dates and there may be multiple purchases on a day
  # # we merge all transactions that occurred on the same day
  # # using dc.MergeTransactionsOnSameDate()
  #
  # elog <- dc.MergeTransactionsOnSameDate(elog)
  # head(elog)
  # summary(elog)  # no NAs
  #
  # ############################################
  # #
  # # EXAMINE DATA
  # #
  # ############################################
  #
  # # make log plot and plot sales
  #
  # ggplot(elog, aes(x=date,y=sales,group=cust))+
  #   geom_line(alpha=0.1)+
  #   scale_x_date()+
  #   scale_y_log10()+
  #   ggtitle("Sales for individual customers")+
  #   ylab("Sales ($, US)")+xlab("")+
  #   theme_minimal()
  #
  # # look at days between orders
  # # model describes rates via a gamma distribution across customers
  #
  # purchaseFreq <- ddply(elog, .(cust), summarize,
  #                       daysBetween = as.numeric(diff(date)))
  #
  # windows();ggplot(purchaseFreq,aes(x=daysBetween))+
  #   geom_histogram(fill="orange")+
  #   xlab("Time between purchases (days)")+
  #   theme_minimal()
  #
  # #(fitg<-fitdist(daysBetween$daysBetween,"gamma",method="mme"))
  # #windows();plot(fitg)
  #
  # ############################################
  # #
  # # DIVIDE DATA
  # #
  # ############################################
  #
  #
  # # into a calibration phase
  # # and a holdout phase
  #
  # # determine middle point for splitting
  # (end.of.cal.period <-
  #    min(elog$date)+as.numeric((max(elog$date)-min(elog$date))/2))
  #
  #
  # # split data into train(calibration) and test (holdout) and make matrices
  # data <- dc.ElogToCbsCbt(elog, per="week",
  #                         T.cal=end.of.cal.period,
  #                         merge.same.date=TRUE, # not needed, we already did it
  #                         statistic = "freq")   # which CBT to return
  #
  # # take a look
  # str(data)
  #
  # # cbs is short for "customer-by-sufficient-statistic” matrix
  # #               with the sufficient stats being:
  # #                       frequency
  # #                       recency (time of last transaction) and
  # #                       total time observed
  #
  # # extract calibration matrix
  # cal2.cbs <- as.matrix(data[[1]][[1]])
  # str(cal2.cbs)
  #
  # ############################################
  # #
  # # ESTIMATE PARAMETERS FOR MODEL
  # #
  # ############################################
  #
  # # initial estimate
  # (params2 <- pnbd.EstimateParameters(cal2.cbs))
  #
  # # look at log likelihood
  #
  # (LL <- pnbd.cbs.LL(params2, cal2.cbs))
  #
  #
  # # make a series of estimates, see if they converge
  # p.matrix <- c(params2, LL)
  # for (i in 1:20) {
  #   params2 <- pnbd.EstimateParameters(cal2.cbs, params2)
  #   LL <- pnbd.cbs.LL(params2, cal2.cbs)
  #   p.matrix.row <- c(params2, LL)
  #   p.matrix <- rbind(p.matrix, p.matrix.row)
  # }
  #
  # # examine
  # p.matrix
  #
  # # use final set of values
  # (params2 <- p.matrix[dim(p.matrix)[1],1:4])
  #
  # # Main model params are :
  #
  # # r          gamma parameter for NBD transaction
  # # alpha      gamma parameter for NBD transaction
  # # s          gamma parameter for Pareto (exponential gamma) dropout process
  # # beta       gammma parameter for Pareto (exponential gamma) dropout process
  #
  #
  # ############################################
  # #
  # # PLOT LOG-LIKELIHOOD ISO-CONTOURS FOR MAIN PARAMS
  # #
  # ############################################
  #
  # # set up parameter names for a more descriptive result
  # param.names <- c("r", "alpha", "s", "beta")
  #
  # LL <- pnbd.cbs.LL(params2, cal2.cbs)
  #
  # dc.PlotLogLikelihoodContours(pnbd.cbs.LL, params2, cal.cbs = cal2.cbs , n.divs = 5,
  #                              num.contour.lines = 7, zoom.percent = 0.3,
  #                              allow.neg.params = FALSE, param.names = param.names)
  #
  #
  # ############################################
  # #
  # # PLOT GROUP DISTRIBUTION OF PROPENSITY TO PURCHASE, DROPOUT
  # #
  # ############################################
  #
  # # par to make two plots side by side
  # par(mfrow=c(1,2))
  #
  # # Plot the estimated distribution of lambda
  # # (customers' propensities to purchase)
  # pnbd.PlotTransactionRateHeterogeneity(params2, lim = NULL)
  # # lim is upper xlim
  # # Plot estimated distribution of gamma
  # # (customers' propensities to drop out).
  #
  # pnbd.PlotDropoutRateHeterogeneity(params2)
  #
  # # set par to normal
  # par(mfrow=c(1,1))
  #
  # ############################################
  # #
  # # EXAMINE INDIVIDUAL PREDICTIONS
  # #
  # ############################################
  #
  # # estimate number transactions a new customer
  # # will make in 52 weeks
  # pnbd.Expectation(params2, t = 52)
  #
  # # expected characteristics for a specific individual,
  # # conditional on their purchasing behavior during calibration
  #
  # # calibration data for customer 1516
  # # frequency("x"), recency("t.x") and total time observed("T.cal")
  #
  # cal2.cbs["1516",]
  # x <- cal2.cbs["1516", "x"]         # x is frequency
  # t.x <- cal2.cbs["1516", "t.x"]     # t.x is recency, ie time of last transactions
  # T.cal <- cal2.cbs["1516", "T.cal"] # T.cal is total time observed
  #
  # # estimate transactions in a T.star-long duration for that cust
  # pnbd.ConditionalExpectedTransactions(params2, T.star = 52, # weeks
  #                                      x, t.x, T.cal)
  #
  #
  # ############################################
  # #
  # # PROBABILITY A CUSTOMER IS ALIVE AT END OF CALIBRATION / TRAINING
  # #
  # ############################################
  #
  # x           # freq of purchase
  # t.x         # week of last purchase
  # T.cal <- 39 # week of end of cal, i.e. present
  # pnbd.PAlive(params2, x, t.x, T.cal)
  #
  # # To visualize the distribution of P(Alive) across customers:
  # params3 <- pnbd.EstimateParameters(cal2.cbs)
  # p.alives <- pnbd.PAlive(params3, cal2.cbs[,"x"], cal2.cbs[,"t.x"], cal2.cbs[,"T.cal"])
  #
  # ggplot(as.data.frame(p.alives),aes(x=p.alives))+
  #   geom_histogram(colour="grey",fill="orange")+
  #   ylab("Number of Customers")+
  #   xlab("Probability Customer is 'Live'")+
  #   theme_minimal()
  #
  # # plot actual & expected customers binned by num of repeat transactions
  # pnbd.PlotFrequencyInCalibration(params2, cal2.cbs,
  #                                 censor=10, title="Model vs. Reality during Calibration")
  #
  #
  # ############################################
  # #
  # # HOW WELL DOES MODEL DO IN HOLDOUT PERIOD?
  # #
  # ############################################
  #
  # # get holdout transactions from dataframe data, add in as x.star
  #
  # x.star   <- data[[2]][[2]][,1]
  # cal2.cbs <- cbind(cal2.cbs, x.star)
  # str(cal2.cbs)
  #
  # holdoutdates <- attributes(data[[2]][[1]])[[2]][[2]]
  # holdoutlength <- round(as.numeric(max(as.Date(holdoutdates))-
  #                                     min(as.Date(holdoutdates)))/7)
  #
  # # plot predicted vs seen conditional freqs and get matrix 'comp' w values
  #
  # T.star <- holdoutlength
  # censor <- 10 # Bin all order numbers here and above
  # comp <- pnbd.PlotFreqVsConditionalExpectedFrequency(params2, T.star,
  #                                                     cal2.cbs, x.star, censor)
  # rownames(comp) <- c("act", "exp", "bin")
  # comp
  #
  # # plot predicted vs actual by week
  #
  # # get data without first transaction, this removes those who buy 1x
  # removedFirst.elog <- dc.SplitUpElogForRepeatTrans(elog)$repeat.trans.elog
  # removedFirst.cbt <- dc.CreateFreqCBT(removedFirst.elog)
  #
  # # get all data, so we have customers who buy 1x
  # allCust.cbt <- dc.CreateFreqCBT(elog)
  #
  # # add 1x customers into matrix
  # tot.cbt <- dc.MergeCustomers(data.correct=allCust.cbt,
  #                              data.to.correct=removedFirst.cbt)
  #
  #
  # lengthInDays <- as.numeric(max(as.Date(colnames(tot.cbt)))-
  #                              min(as.Date(colnames(tot.cbt))))
  # origin <- min(as.Date(colnames(tot.cbt)))
  #
  # tot.cbt.df <- melt(tot.cbt,varnames=c("cust","date"),value.name="Freq")
  # tot.cbt.df$date<-as.Date(tot.cbt.df$date)
  # tot.cbt.df$week<-as.numeric(1+floor((tot.cbt.df$date-origin+1)/7))
  #
  # transactByDay  <- ddply(tot.cbt.df,.(date),summarize,sum(Freq))
  # transactByWeek <- ddply(tot.cbt.df,.(week),summarize,sum(Freq))
  # names(transactByWeek) <- c("week","Transactions")
  # names(transactByDay)  <- c("date","Transactions")
  #
  #
  # T.cal <- cal2.cbs[,"T.cal"]
  # T.tot <- 78 # end of holdout
  # comparisonByWeek <- pnbd.PlotTrackingInc(params2, T.cal,
  #                                          T.tot, actual.inc.tracking.data=transactByWeek$Transactions)
  #
  # ############################################
  # #
  # # FORMAL MEASURE OF ACCURACY
  # #
  # ############################################
  #
  # # root mean squared error
  # rmse <- function(est, act) { return(sqrt(mean((est-act)^2))) }
  #
  # # mean squared logarithmic error
  # msle <- function(est, act) { return(mean((log1p(est)-log1p(act))^2)) }
  #
  # str(cal2.cbs)
  #
  # cal2.cbs[,"x"]
  #
  # predict<-pnbd.ConditionalExpectedTransactions(params2, T.star = 38, # weeks
  #                                               x     = cal2.cbs[,"x"],
  #                                               t.x   = cal2.cbs[,"t.x"],
  #                                               T.cal = cal2.cbs[,"T.cal"])
  #
  # cal2.cbs[,"x.star"]  # actual transactions for each person
  #
  #
  # rmse(act=cal2.cbs[,"x.star"],est=predict)
  # msle(act=cal2.cbs[,"x.star"],est=predict)
  #
  # # not useful w/o comparison: is this better than guessing?


  ## ------------------------------------------------------------------------
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

