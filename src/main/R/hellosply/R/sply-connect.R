#' open a (local) spark connection
#'
#' This function optains a 'local' sperk connection.
#'
#' Note: $SPARK_HONE/bin in path.
#'
#' @return An active spark connection
#' @import sparklyr
#' @export
open_connection_local <- function(){
  sc <- spark_connect(master = "local")
  sc
}

#' open a (local) spark connection
#'
#' This function optains a 'local' sperk connection.
#'
#' Note: $SPARK_HONE/bin in path.
#'
#' @return An active spark connection
#' @import sparklyr
#' @export
open_connection_cluster <- function(){

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
  sc
}

#' open a (local) spark connection
#'
#' This function optains a 'local' sperk connection.
#'
#' Note: $SPARK_HONE/bin in path.
#'
#' @return An active spark connection
#' @import sparklyr
#' @export
open_connection <- function(){
  sc <- open_connection_cluster
  sc
}

#' create spark connection
#'
#' This function optains a 'local' sperk connection.
#'
#' Note: $SPARK_HONE/bin in path.
#'
#' @param sc an active spark connection
#' @import sparklyr
#' @export
close_connection <- function(sc){
  spark_disconnect(sc)
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
check_spark_version <- function(){

  sc <- open_connection()
  result <- spark_version(sc)
  close_connection(sc)

  result

}

