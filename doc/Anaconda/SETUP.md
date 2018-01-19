ENVIRONMENT SETUP
=================



USER ENV
--------


### bash

```

cat >> ~/.bashrc <<EOF


#export SPARK_HOME=/usr/hdp/2.5.0.0-1245/spark2
export SPARK_MAJOR_VERSION=2
export SPARK_HOME=/usr/hdp/current/spark2-client/

# fix: python-2/3 problem
# in /usr/hdp/2.5.0.0-1245/spark2/bin/load-spark-env.sh
#
#  export HDP_VERSION=`hdp-select status | grep spark2-client | awk -F " " '{print $3}'`
#
export HDP_VERSION='2.5.0.0-1245'

# added by Anaconda3 installer
export PATH="/home/developer/anaconda3/bin:$PATH"


# RE-prepend system path on top (hdp with sys.python2.6)
export PATH="/usr/bin:$PATH"



EOF

```


### zsh

```

cat >> ~/.zshrc <<EOF


# User specific aliases and functions

#export SPARK_HOME=/usr/hdp/2.5.0.0-1245/spark2
export SPARK_MAJOR_VERSION=2
export SPARK_HOME=/usr/hdp/current/spark2-client/

# fix: python-2/3 problem
# in /usr/hdp/2.5.0.0-1245/spark2/bin/load-spark-env.sh
#
#  export HDP_VERSION=`hdp-select status | grep spark2-client | awk -F " " '{print $3}'`
#
export HDP_VERSION='2.5.0.0-1245'


# added by Anaconda3 installer
export PATH="/home/developer/anaconda3/bin:$PATH"



EOF

```



HDP PYTHON SUPPORT
------------------


* https://www.google.com/search?q=topology_script.py+python2.6+hdp
* https://community.hortonworks.com/questions/46454/use-of-python-version-3-scripts-for-pyspark-with-h.html
* https://community.hortonworks.com/questions/16094/pyspark-with-different-python-versions-on-yarn-is.html



```

export PYSPARK_PYTHON=~/anaconda3/bin/python3

export LD_LIBRARY_PATH=~/anaconda3/lib
 
export PYTHONHASHSEED=0


```

```

head $(which hdp-select)

hdp-select status | grep spark2-client | awk -F " " '{print $3}'

export HDP_VERSION='2.5.0.0-1245'

 

cat /usr/hdp/current/spark-client/conf/spark-env.sh | less

cat /usr/hdp/2.5.0.0-1245/spark2/bin/load-spark-env.sh | grep -A20 HDP_VERSION


```



```
head /etc/hadoop/conf/topology_script.py


#!/usr/bin/env python


```

```
head /etc/hadoop/conf/topology_script.py


#!/usr/bin/env python2.6

#+/usr/bin/python2.6


```