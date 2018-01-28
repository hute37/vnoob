CONDA PACKAGES
==============


R BASE
------

```
export Y=-y

conda install $Y -c r r-essentials


```

R DEVTOOLS
----------

```

conda install $Y -c r r-devtools
conda install $Y -c r r-roxygen2
conda install $Y -c r r-testthat

```

R-STUDIO
--------

```
conda install $Y -c r rstudio



```



R MISC
------

```

conda install $Y -c r r-rserve
conda install $Y -c r r-rcurl
conda install $Y -c r r-RJSONIO
conda install $Y -c r r-jpeg
conda install $Y -c r r-png

# conda install --channel https://conda.anaconda.org/bioconda bioconductor-edger


```



R SPARK
-------

```

conda install $Y -c r r-sparklyr
conda install $Y -c anaconda h2o



```

R SCALA
-------

```

# conda install $Y -c dbdahl r-scala


```




R DATASETS
-------

```

conda install $Y -c r r-nycflights13
conda install $Y -c r r-lahman


```




DATA APP
--------


```

conda install $Y -c ntblok r-btyd 


```



```

~ conda install -c ntblok r-btyd

## Package Plan ##

  environment location: /home/developer/anaconda3

  added / updated specs: 
    - r-btyd


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    r-desolve-1.20             |   r342h9ac9557_0         2.1 MB  ntblok
    r-elliptic-1.3_7           |           r342_0         1.1 MB  ntblok
    r-hypergeo-1.2_13          |           r342_0         278 KB  ntblok
    r-btyd-2.4                 |           r342_0         696 KB  ntblok
    r-contfrac-1.1_11          |   r342h14c3975_0          29 KB  ntblok
    ------------------------------------------------------------
                                           Total:         4.2 MB

The following NEW packages will be INSTALLED:

    r-btyd:     2.4-r342_0            ntblok
    r-contfrac: 1.1_11-r342h14c3975_0 ntblok
    r-desolve:  1.20-r342h9ac9557_0   ntblok
    r-elliptic: 1.3_7-r342_0          ntblok
    r-hypergeo: 1.2_13-r342_0         ntblok

Proceed ([y]/n)? 





```
