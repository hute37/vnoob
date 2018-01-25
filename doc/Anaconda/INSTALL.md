ANACONDA INSTALL
================


DOWNLOAD
--------


* https://www.anaconda.com/download/#linux


INSTALL
-------


```


wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
chmod +x ./Anaconda3-5.0.1-Linux-x86_64.sh
./Anaconda3-5.0.1-Linux-x86_64.sh 


```

SETUP
-----

* [env config](SETUP.md)
* [packages, R](PKGS.md)



CHECK
---------

```
conda -V

which python
which python3
which python2
which python2.6

env python --version

jupyter  kernelspec list 

jupyter console
jupyter console --kernel=ir  

R --version

java --version

env | sort

echo "JAVA_HOME=$JAVA_HOME" 

echo "SPARK_HOME=$SPARK_HOME" 
echo "CONDA_HOME=$CONDA_HOME" 

echo "PYSPARK_PYTHON=$PYSPARK_PYTHON" 

echo "SPARK_MAJOR_VERSION=$SPARK_MAJOR_VERSION" 
echo "HDP_VERSION=$HDP_VERSION" 


```



CLOUD
-----

* https://anaconda.org/hute37/dashboard
* https://docs.anaconda.com/anaconda-cloud/user-guide/getting-started#finding-downloading-and-installing-packages
* https://docs.anaconda.com/anaconda-cloud/user-guide/tasks/work-with-packages


```

conda install anaconda-client
conda install conda-build

anaconda login


```




CLOUD - Building and uploading packages
---------------------------------------


```

mkdir -p ~/work/ec
cd ~/work/ec

git clone https://github.com/Anaconda-Platform/anaconda-client
cd anaconda-client/example-packages/conda/

conda config --set anaconda_upload no
conda build .

conda build . --output

#anaconda login
#anaconda upload /your/path/conda-package.tar.bz2

```




CLOUD - Sharing notebooks
-------------------------


```
anaconda upload my-notebook.ipynb

firefox http://notebooks.anaconda.org/<USERNAME>/my-notebook

anaconda download username/my-notebook

```


CLOUD - Sharing environments
----------------------------


```

conda env export -n my-environment -f my-environment.yml

conda env upload -f my-environment.yml

firefox http://envs.anaconda.org/<USERNAME>

conda env create user/my-environment

source activate my-environment

```




NAVIGATOR
---------

```
anaconda-navigator 

```

