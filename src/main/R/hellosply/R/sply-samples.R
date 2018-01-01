#' count IRIS rows
#'
#' This function read iris dataset pushd by sparklyr::copy_to
#' via SQL DBI interface to spark sql.
#'
#' Note: spark connection is allocated in function, with no cleanup
#'
#' @return A count of iris dataset rows by species
#' @export
iris_count <- function(){

  # library(sparklyr)
  # library(dplyr)
  # library(DBI)

  sc <- sparklyr::spark_connect(master = "local")

  iris_tbl <- dplyr::copy_to(sc, datasets::iris)

  iris_count <- DBI::dbGetQuery(sc, "SELECT Species, count(*) as Species_Count FROM iris group by Species")
  iris_count

}
