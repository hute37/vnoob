ANACONDA DEPLOY
===============


DOWNLOAD
--------


* https://www.anaconda.com/download/#linux


DISTRO
------


```

sudo mkdir -p /opt

df -h
ls /grid/0 

export BASE_GRID=/grid/0

sudo mkdir -p /grid/0/opt/sc

sudo chown developer:cdata  /grid/0/opt/sc

sudo ln -s /grid/0/opt/sc /opt/sc


touch /opt/sc/test.txt
ls -l /opt/sc
ls -l /opt/sc/
rm /opt/sc/test.txt


mkdir -p /opt/sc/setup

ls -l  /opt/sc/

```



```

scp /opt/sc/setup/* s1:/opt/sc/setup/
scp /opt/sc/setup/* s2:/opt/sc/setup/
scp /opt/sc/setup/* s3:/opt/sc/setup/

```



```

cd /opt/sc/setup

wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh
chmod +x ./Anaconda3-5.0.1-Linux-x86_64.sh


# ./Anaconda3-5.0.1-Linux-x86_64.sh 


```




```

bash  /opt/sc/setup/Anaconda3-5.0.1-Linux-x86_64.sh -b -p /opt/sc/anaconda3

export PATH="/opt/sc/anaconda3/bin:$PATH"

which python

conda --version



```


NEXT
====

* [R Setup](PKGS.md)


