# vnoob
Spark scratchpad

## Run

```$bash

sbt package


spark-submit --class=org.here.hellosply.app.Application --master "local[4]" ~/work/sb/vnoob/target/scala-2.11/vnoob_2.11-0.1.jar



```


## Env

``` bash

cat /etc/profile.d/apache-spark.sh 

export SPARK_HOME=/opt/srv/apache/spark
export PATH=$PATH:$SPARK_HOME/bin

```