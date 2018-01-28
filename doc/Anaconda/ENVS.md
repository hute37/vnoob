CONDA ENVIRONMENTS
==================


CREATE ENV
----------

```

conda create --name rscala

conda info --envs

source activate rscala

conda info --envs

```

CRAN INSTALL
------------

### PACKRAT

* [Packrat](https://rstudio.github.io/packrat/)
* [Using Packrat with RStudio](http://rstudio.github.io/packrat/rstudio.html)
* [Packrat Alternative](http://ihrke.github.io/conda.html)


### CRAN GLOBAL

```
which R ; which python ; which java ; which scala


# R CMD INSTALL ...

```



CONDA BUILD PREPARE
-------------------

```
conda config --add channels r

conda create --name testenv r
source activate testenv



```



CONDA CRAN BUILD
----------------

* @see: http://ihrke.github.io/conda.html

```
RPKG='rstan'

#conda skeleton cran stanheaders
#conda skeleton cran inline

conda skeleton cran $RPKG

conda config --set anaconda_upload no

conda build r-$RPKG


conda build .

conda build . --output

#anaconda login
#anaconda upload /your/path/conda-package.tar.bz2


```

CONDA CRAN PUBLISH
----------------

```
RPKG='rstan'

conda skeleton cran $RPKG
conda config --set anaconda_upload no

conda build r-$RPKG --output

#anaconda login
#anaconda upload /your/path/conda-package.tar.bz2


```

R SCALA
-------

```
RPKG='rscala'


conda info --envs

conda config --add channels r

conda create --name rscala r
source activate rscala

conda info --envs

conda skeleton cran $RPKG
conda config --set anaconda_upload no

conda build r-$RPKG --output

#anaconda login
#anaconda upload /your/path/conda-package.tar.bz2


```


