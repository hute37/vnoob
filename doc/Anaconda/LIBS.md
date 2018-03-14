R SETUP
========


* https://medium.com/@GalarnykMichael/install-r-and-rstudio-on-ubuntu-12-04-14-04-16-04-b6b3107f7779
* https://www.r-bloggers.com/how-to-install-r-on-linux-ubuntu-16-04-xenial-xerus/



Debian/Ubuntu
-------------


```

apt-key adv –keyserver keyserver.ubuntu.com –recv-keys E084DAB9

# Ubuntu 12.04: precise
# Ubuntu 14.04: trusty
# Ubuntu 16.04: xenial
# Basic format of next line deb https://<my.favorite.cran.mirror>/bin/linux/ubuntu <enter your ubuntu version>/
add-apt-repository 'deb https://cran.stat.unipd.it/bin/linux/ubuntu xenial/'


apt-get update
apt-get install r-base
apt-get install r-base-dev

apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev

# Download and Install RStudio
sudo apt-get install gdebi-core
wget https://download1.rstudio.org/rstudio-1.0.44-amd64.deb
sudo gdebi rstudio-1.0.44-amd64.deb
rm rstudio-1.0.44-amd64.deb

```



OS PACKAGES
===========


Debian/Ubuntu
-------------


```


apt-get install libmysqlclient-dev 

apt-get install libgsl2  libgsl-dev gsl-bin  gsl-ref-html  gsl-ref-psdoc



```


### LaTeX/Knitr

```

apt-get install texlive-full


```

----------------------------------------------------------------

CentOS
------


```

yum install mysql-devel

```




### LaTeX/Knitr

```

yum -y install texlive texlive-*.noarch

```
