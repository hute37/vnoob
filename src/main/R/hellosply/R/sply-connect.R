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
  spark_home <- Sys.getenv("SPARK_HOME")
  print("")
  print(sprintf("SPARK_HOME='%s'", spark_home))
  print(sprintf("#spark-connect('local'), ..."))

  sc <- spark_connect(master = "local")

  print(sprintf("#spark-connect('local'), done."))
  return(sc)
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
  spark_default_vers <- '2.1.1.2.6.1.0'

  config <- spark_config()
  config$spark.executor.instances <- 2
  config$spark.executor.cores <- 2
  config$spark.executor.memory <- "1G"

  print("")
  print(sprintf("SPARK_HOME='%s'", spark_home))
  print(sprintf("#spark-connect('yarn-client'), ..."))

  sc <<- spark_connect(master="yarn-client", config=config, version = spark_default_vers)

  print(sprintf("#spark-connect('yarn-client'), done."))

  return(sc)
}

#' check if spark is locally available
#'
#' This function checks SPARK_HOME environment
#'
#' @return Test if local environment
#' @export
is_local_site <- function(){
  is_local_site <- nchar(Sys.getenv("SPARK_HOME")) > 0
  return(is_local_site)
}


#' check YARM cluster runtime
#'
#' This function checks if file: /etc/hadoop/conf/yarn-site.xml
#'
#' @return Test if cluster environment
#' @export
is_cluster_site <- function(){
  is_cluster_site <- file.exists('/etc/hadoop/conf/yarn-site.xml')
  return(is_cluster_site)
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
  if (is_cluster_site()) {
    sc <- open_connection_cluster()
    return(sc)
  } else {
    sc <- open_connection_local()
    return(sc)
  }
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
#' @import sparklyr
#' @export
check_spark_version <- function(){

  sc <- open_connection()
  result <- spark_version(sc)
  close_connection(sc)

  result

}

