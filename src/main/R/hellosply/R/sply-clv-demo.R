#' load BTYD sample dataset
#'
#' This function load sample data and distribute to spark.
#'
#' Note: spark connection is allocated in function, with no cleanup
#'
#' @param sc an active spark connection
#' @return A count of iris dataset rows by species
#' @import dplyr
#' @import sparklyr
#' @import DBI
#' @import BTYD
#' @export
clv_data_load <- function(sc){

  iris_tbl <- copy_to(sc, datasets::iris, name="iris")

  iris_count <- DBI::dbGetQuery(sc, "SELECT Species, count(*) as Species_Count FROM iris group by Species")
  iris_count

}


#' run BTYD demo (auto connection)
#'
#' spark apply evaluatio funcion after local param extimation.
#'
#' Note: spark connection is allocated in function, with no cleanup
#'
#' @return A count of iris dataset rows by species
#' @export
clv_demo_run <- function(){

  sc <- open_connection()
  result <- clv_data_load(sc)
  close_connection(sc)

  result

}

