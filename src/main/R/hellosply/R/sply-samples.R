#' count IRIS rows
#'
#' This function read iris dataset pushd by sparklyr::copy_to
#' via SQL DBI interface to spark sql.
#'
#' Note: spark connection is allocated in function, with no cleanup
#'
#' @param sc an active spark connection
#' @return A count of iris dataset rows by species
#' @import dplyr
#' @import sparklyr
#' @import DBI
#' @export
iris_count <- function(sc){

  iris_tbl <- copy_to(sc, datasets::iris, name="iris")

  iris_count <- DBI::dbGetQuery(sc, "SELECT Species, count(*) as Species_Count FROM iris group by Species")
  iris_count

}


#' count IRIS rows (auto connection)
#'
#' This function read iris dataset pushd by sparklyr::copy_to
#' via SQL DBI interface to spark sql.
#'
#' Note: spark connection is allocated in function, with no cleanup
#'
#' @return A count of iris dataset rows by species
#' @export
iris_count_auto <- function(){

  sc <- open_connection()
  result <- iris_count(sc)
  close_connection(sc)

  result

}

