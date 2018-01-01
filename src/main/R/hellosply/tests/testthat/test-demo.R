context("sample: http://spark.rstudio.com/")

library(sparklyr)
library(dplyr)


setup({
  sc <<- spark_connect(master = "local")
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

  batting_tbl %>%
    select(playerID, yearID, teamID, G, AB:H) %>%
    arrange(playerID, yearID, teamID) %>%
    group_by(playerID) %>%
    filter(min_rank(desc(H)) <= 2 & H > 0)

  expect_true(TRUE)
})



test_that("sply exported function", {

  result <- hellosply::iris_count(sc)

  expect_true(TRUE)
})

