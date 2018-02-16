context("sample: http://spark.rstudio.com/")

library(sparklyr)
library(dplyr)



setup({


  use_spark_yarn <- FALSE

  if (use_spark_yarn) {

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
  } else {
    sc <<- spark_connect(master = "local")
  }

})

teardown({
  spark_disconnect(sc)
})



test_that("SQL access", {

  # install.packages(c("nycflights13"))

  library(DBI)

  iris_tbl <- copy_to(sc, iris, name="iris_test")

  iris_preview <- dbGetQuery(sc, "SELECT * FROM iris_test LIMIT 10")
  iris_preview

  iris_counter <- dbGetQuery(sc, "SELECT Species, count(*) as Species_Count FROM iris_test group by Species")
  iris_counter

  expect_true(TRUE)
})


test_that("can use dplyr tranfornations on 'nycflights13::flights' dataset", {

  # install.packages(c("nycflights13"))



  flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
  src_tbls(sc)


  flights_tbl %>% filter(dep_delay == 2)


  delay <- flights_tbl %>%
    group_by(tailnum) %>%
    summarise(count = n(), dist = mean(distance), delay = mean(arr_delay)) %>%
    filter(count > 20, dist < 2000, !is.na(delay)) %>%
    collect


  # library(ggplot2)
  # ggplot(delay, aes(dist, delay)) +
  #   geom_point(aes(size = count), alpha = 1/2) +
  #   geom_smooth() +
  #   scale_size_area(max_size = 2)


  expect_true(TRUE)
})



test_that("can use dplyr window functions over 'Lahman::Batting' dataset", {

  # install.packages(c("Lahman"))

  batting_tbl <- copy_to(sc, Lahman::Batting, "batting")
  src_tbls(sc)

  batting_players_tbl <- batting_tbl %>%
    select(playerID, yearID, teamID, G, AB:H) %>%
    arrange(playerID, yearID, teamID) %>%
    group_by(playerID) %>%
    filter(min_rank(desc(H)) <= 2 & H > 0)

  batting_players <-batting_players_tbl %>% collect

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

