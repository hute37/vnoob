# vnoob
Spark scratchpad


## Env

``` bash

cat /etc/profile.d/apache-spark.sh 

export SPARK_HOME=/opt/srv/apache/spark
export PATH=$PATH:$SPARK_HOME/bin

```


## R

``` R

R CMD INSTALL --preclean --no-multiarch --with-keep.source hellosply

```


## Run

```$bash

sbt assembly

spark-submit --class=org.here.hellosply.app.Application --master "local[4]" ~/work/sb/vnoob/target/scala-2.11/vnoob-assembly-0.1.jar

```

# Out

```

18/01/01 19:10:10 INFO Utils: Successfully started service 'SparkUI' on port 4040.
18/01/01 19:10:10 INFO SparkUI: Bound SparkUI to 0.0.0.0, and started at http://192.168.1.130:4040
18/01/01 19:10:10 INFO SparkContext: Added JAR file:/home/gio/work/sb/vnoob/target/scala-2.11/vnoob-assembly-0.1.jar at spark://192.168.1.130:44525/jars/vnoob-assembly-0.1.jar with timestamp 1514830210225
18/01/01 19:10:10 INFO Executor: Starting executor ID driver on host localhost
18/01/01 19:10:10 INFO Utils: Successfully started service 'org.apache.spark.network.netty.NettyBlockTransferService' on port 46217.
18/01/01 19:10:10 INFO NettyBlockTransferService: Server created on 192.168.1.130:46217
18/01/01 19:10:10 INFO BlockManager: Using org.apache.spark.storage.RandomBlockReplicationPolicy for block replication policy
18/01/01 19:10:10 INFO BlockManagerMaster: Registering BlockManager BlockManagerId(driver, 192.168.1.130, 46217, None)
18/01/01 19:10:10 INFO BlockManagerMasterEndpoint: Registering block manager 192.168.1.130:46217 with 366.3 MB RAM, BlockManagerId(driver, 192.168.1.130, 46217, None)
18/01/01 19:10:10 INFO BlockManagerMaster: Registered BlockManager BlockManagerId(driver, 192.168.1.130, 46217, None)
18/01/01 19:10:10 INFO BlockManager: Initialized BlockManager: BlockManagerId(driver, 192.168.1.130, 46217, None)
R code:

library("hellosply")

a <-iris_count_auto()

aSpecies <- a$Species
aCount <- a$Species_Count

    

R eval, ...
R eval, done.

 a := 

(versicolor,50)
(virginica,50)
(setosa,50)




18/01/01 19:10:57 INFO SparkUI: Stopped Spark web UI at http://192.168.1.130:4040
18/01/01 19:10:58 INFO MapOutputTrackerMasterEndpoint: MapOutputTrackerMasterEndpoint stopped!
18/01/01 19:10:59 INFO MemoryStore: MemoryStore cleared
18/01/01 19:10:59 INFO BlockManager: BlockManager stopped
18/01/01 19:10:59 INFO BlockManagerMaster: BlockManagerMaster stopped
18/01/01 19:10:59 INFO OutputCommitCoordinator$OutputCommitCoordinatorEndpoint: OutputCommitCoordinator stopped!
18/01/01 19:10:59 INFO SparkContext: Successfully stopped SparkContext
18/01/01 19:10:59 INFO ShutdownHookManager: Shutdown hook called
18/01/01 19:10:59 INFO ShutdownHookManager: Deleting directory /tmp/spark-dd600f52-1db5-4931-b5a0-08629495e3ac



```