ENVIRONMENT SETUP
=================



SCALA (TOREE)
-------------



```

# conda install -c izoda toree 

conda create --name jupyter python=3
source activate jupyter
conda install jupyter
pip install --pre toree
jupyter toree install



```



RUN JUPYTER
-----------



```
urxvt -geometry 190x55 -e zsh --login

ssh -L 8891:localhost:8891 d9

```

JUPYTER HOWTO
-------------

* https://stackoverflow.com/questions/37214610/how-to-install-apache-toree-for-spark-kernel-in-jupyter-in-anaconda-environmen/37218374#37218374
* https://blog.thedataincubator.com/2017/04/spark-2-0-on-jupyter-with-toree/
* https://mapr.com/blog/python-pyspark-condas-pt1/
* https://mapr.com/blog/configure-jupyter-spark-python/
* https://mapr.com/blog/sparkr-r-interactive-shell/


