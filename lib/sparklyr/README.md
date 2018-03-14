CONDA ENVIRONMENTS
==================



CONDA CRAN BUILD
----------------

* @see: http://ihrke.github.io/conda.html


R SCALA
-------

```
RPKG='rscala'


conda skeleton cran $RPKG
conda config --set anaconda_upload no

conda build r-$RPKG --output

#anaconda login
#anaconda upload /your/path/conda-package.tar.bz2


```

-------------------------------------------------------------------------------


```

➜  rscala git:(master) ✗ conda skeleton cran $RPKG

Tip: install CacheControl and lockfile (conda packages) to cache the CRAN metadata
Fetching metadata from https://cran.r-project.org/
Parsing input package rscala:
.. name: rscala location: None new_location: /home/gio/work/vn/vnoob/lib/rscala/r-rscala
Making/refreshing recipe for rscala
Tip: install CacheControl and lockfile (conda packages) to cache the CRAN metadata
Downloading source from https://cran.r-project.org/src/contrib/rscala_2.5.0.tar.gz
Source cache directory is: /opt/sc/anaconda3/conda-bld/src_cache
No hash (md5, sha1, sha256) provided.  Source download forced.  Add hash to recipe to use source cache.
WARNING:conda_build.source:No hash (md5, sha1, sha256) provided.  Source download forced.  Add hash to recipe to use source cache.
Downloading source to cache: rscala_2.5.0.tar.gz
Downloading https://cran.r-project.org/src/contrib/rscala_2.5.0.tar.gz
Success
Writing recipe for rscala
--dirty flag and --keep-old-work not specified.Removing build/test folder after successful build/test.

INFO:conda_build.config:--dirty flag and --keep-old-work not specified.Removing build/test folder after successful build/test.










➜  rscala git:(master) ✗ conda build r-$RPKG                                                             
Adding in variants from internal_defaults
INFO:conda_build.variants:Adding in variants from internal_defaults
Attempting to finalize metadata for r-rscala
INFO:conda_build.metadata:Attempting to finalize metadata for r-rscala
Solving environment: ...working... done
Solving environment: ...working... done
BUILD START: ['r-rscala-2.5.0-r342_0.tar.bz2']
Solving environment: ...working... done

## Package Plan ##

  environment location: /opt/sc/anaconda3/conda-bld/r-rscala_1517152034143/_h_env_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placeho


The following NEW packages will be INSTALLED:

    bzip2:           1.0.6-h6d464ef_2     
    ca-certificates: 2017.08.26-h1d4fec5_0
    cairo:           1.14.12-h77bcde2_0   
    curl:            7.57.0-h84994c4_0    
    fontconfig:      2.12.4-h88586e7_1    
    freetype:        2.8-hab7d2ae_1       
    glib:            2.53.6-h5d9569c_2    
    graphite2:       1.3.10-hf63cedd_1    
    gsl:             2.2.1-h0c605f7_3     
    harfbuzz:        1.7.4-hc5b324e_0     
    icu:             58.2-h9c2bf20_1      
    jpeg:            9b-h024ee3a_2        
    krb5:            1.14.2-hcdc1b81_6    
    libcurl:         7.57.0-h1ad7b7a_0    
    libffi:          3.2.1-hd88cf55_4     
    libgcc-ng:       7.2.0-h7cc24e2_2     
    libgfortran-ng:  7.2.0-h9f7466a_2     
    libpng:          1.6.34-hb9fc6fc_0    
    libssh2:         1.8.0-h9cfc8f7_4     
    libstdcxx-ng:    7.2.0-h7a57d05_2     
    libtiff:         4.0.9-h28f6b97_0     
    libxcb:          1.12-hcd93eb1_4      
    libxml2:         2.9.7-h26e45fe_0     
    ncurses:         6.0-h9df7e31_2       
    openssl:         1.0.2n-hb7f436b_0    
    pango:           1.41.0-hd475d92_0    
    pcre:            8.41-hc27e229_1      
    pixman:          0.34.0-hceecf20_3    
    r-base:          3.4.2-haf99962_0     
    readline:        7.0-ha6073c6_4       
    tk:              8.6.7-hc745277_3     
    xz:              5.2.3-h55aa19d_2     
    zlib:            1.2.11-ha838bed_2    

Preparing transaction: ...working... done
Verifying transaction: ...working... done
Executing transaction: ...working... done
Solving environment: ...working... done
Source cache directory is: /opt/sc/anaconda3/conda-bld/src_cache
Found source in cache: rscala_2.5.0_0811e518b5.tar.gz
Extracting download
source tree in: /opt/sc/anaconda3/conda-bld/r-rscala_1517152034143/work
* installing to library ‘/opt/sc/anaconda3/conda-bld/r-rscala_1517152034143/_h_env_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placeho/lib/R/library’
* installing *source* package ‘rscala’ ...
** package ‘rscala’ successfully unpacked and MD5 sums checked
** R
** inst
** preparing package for lazy loading
** help
*** installing help indices
** building package indices
** installing vignettes
** testing if installed package can be loaded
* creating tarball
packaged installation of ‘rscala’ as ‘rscala_2.5.0_R_x86_64-conda_cos6-linux-gnu.tar.gz’
* DONE (rscala)
Packaging r-rscala
INFO:conda_build.build:Packaging r-rscala
Packaging r-rscala-2.5.0-r342_0
INFO:conda_build.build:Packaging r-rscala-2.5.0-r342_0
number of files: 35
Fixing permissions
Fixing permissions
updating: r-rscala-2.5.0-r342_0.tar.bz2
TEST START: /opt/sc/anaconda3/conda-bld/noarch/r-rscala-2.5.0-r342_0.tar.bz2
Updating index at /opt/sc/anaconda3/conda-bld/linux-64 to make package installable with dependencies
INFO:conda_build.build:Updating index at /opt/sc/anaconda3/conda-bld/linux-64 to make package installable with dependencies
Updating index at /opt/sc/anaconda3/conda-bld/noarch to make package installable with dependencies
INFO:conda_build.build:Updating index at /opt/sc/anaconda3/conda-bld/noarch to make package installable with dependencies
Adding in variants from /tmp/tmpc7a904q5/info/recipe/conda_build_config.yaml
INFO:conda_build.variants:Adding in variants from /tmp/tmpc7a904q5/info/recipe/conda_build_config.yaml
Renaming work directory,  /opt/sc/anaconda3/conda-bld/r-rscala_1517152034143/work  to  /opt/sc/anaconda3/conda-bld/r-rscala_1517152034143/work_moved_r-rscala-2.5.0-r342_0_linux-64
Solving environment: ...working... done

## Package Plan ##

  environment location: /opt/sc/anaconda3/conda-bld/r-rscala_1517152034143/_test_env_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_plac


The following NEW packages will be INSTALLED:

    bzip2:           1.0.6-h6d464ef_2           
    ca-certificates: 2017.08.26-h1d4fec5_0      
    cairo:           1.14.12-h77bcde2_0         
    curl:            7.57.0-h84994c4_0          
    fontconfig:      2.12.4-h88586e7_1          
    freetype:        2.8-hab7d2ae_1             
    glib:            2.53.6-h5d9569c_2          
    graphite2:       1.3.10-hf63cedd_1          
    gsl:             2.2.1-h0c605f7_3           
    harfbuzz:        1.7.4-hc5b324e_0           
    icu:             58.2-h9c2bf20_1            
    jpeg:            9b-h024ee3a_2              
    krb5:            1.14.2-hcdc1b81_6          
    libcurl:         7.57.0-h1ad7b7a_0          
    libffi:          3.2.1-hd88cf55_4           
    libgcc-ng:       7.2.0-h7cc24e2_2           
    libgfortran-ng:  7.2.0-h9f7466a_2           
    libpng:          1.6.34-hb9fc6fc_0          
    libssh2:         1.8.0-h9cfc8f7_4           
    libstdcxx-ng:    7.2.0-h7a57d05_2           
    libtiff:         4.0.9-h28f6b97_0           
    libxcb:          1.12-hcd93eb1_4            
    libxml2:         2.9.7-h26e45fe_0           
    ncurses:         6.0-h9df7e31_2             
    openssl:         1.0.2n-hb7f436b_0          
    pango:           1.41.0-hd475d92_0          
    pcre:            8.41-hc27e229_1            
    pixman:          0.34.0-hceecf20_3          
    r-base:          3.4.2-haf99962_0           
    r-rscala:        2.5.0-r342_0          local
    readline:        7.0-ha6073c6_4             
    tk:              8.6.7-hc745277_3           
    xz:              5.2.3-h55aa19d_2           
    zlib:            1.2.11-ha838bed_2          

Preparing transaction: ...working... done
Verifying transaction: ...working... done
Executing transaction: ...working... done
+ /opt/sc/anaconda3/conda-bld/r-rscala_1517152034143/_test_env_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_placehold_plac/bin/R -e 'library('\''rscala'\'')'

R version 3.4.2 (2017-09-28) -- "Short Summer"
Copyright (C) 2017 The R Foundation for Statistical Computing
Platform: x86_64-conda_cos6-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> library('rscala')
> 
> 
+ exit 0
TEST END: /opt/sc/anaconda3/conda-bld/noarch/r-rscala-2.5.0-r342_0.tar.bz2
# Automatic uploading is disabled
# If you want to upload package(s) to anaconda.org later, type:

anaconda upload /opt/sc/anaconda3/conda-bld/noarch/r-rscala-2.5.0-r342_0.tar.bz2

# To have conda build upload to anaconda.org automatically, use
# $ conda config --set anaconda_upload yes

anaconda_upload is not set.  Not uploading wheels: []



####################################################################################
Source and build intermediates have been left in /opt/sc/anaconda3/conda-bld.
There are currently 2 accumulated.
To remove them, you can run the ```conda build purge``` command








➜  rscala git:(master) ✗ anaconda upload /opt/sc/anaconda3/conda-bld/noarch/r-rscala-2.5.0-r342_0.tar.bz2
Using Anaconda API: https://api.anaconda.org
detecting file type ...
conda
extracting package attributes for upload ...
done

Uploading file hute37/r-rscala/2.5.0/noarch/r-rscala-2.5.0-r342_0.tar.bz2 ... 
 uploaded 918 of 918Kb: 100.00% ETA: 0.0 minutes


Upload(s) Complete

package located at:
https://anaconda.org/hute37/r-rscala




➜  r-rscala git:(master) ✗ conda list r-rscala
# packages in environment at /opt/sc/anaconda3:
#
# Name                    Version                   Build  Channel

➜  r-rscala git:(master) ✗ conda remove r-rscala
Solving environment: failed

PackagesNotFoundError: The following packages are missing from the target environment:
  - r-rscala


➜  r-rscala git:(master) ✗ conda install $Y -c hute37 r-rscala
Solving environment: done

## Package Plan ##

  environment location: /opt/sc/anaconda3

  added / updated specs: 
    - r-rscala


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    r-rscala-2.5.0             |           r342_0         914 KB  hute37

The following NEW packages will be INSTALLED:

    r-rscala: 2.5.0-r342_0 hute37

Proceed ([y]/n)? 


Downloading and Extracting Packages
r-rscala 2.5.0: ######################################################################################## | 100% 
Preparing transaction: done
Verifying transaction: done
Executing transaction: done


➜  r-rscala git:(master) ✗ conda list r-rscala              
# packages in environment at /opt/sc/anaconda3:
#
# Name                    Version                   Build  Channel
r-rscala                  2.5.0                    r342_0    hute37



```


DEPLOY PKGS
------------


```

conda list r-rscala
conda remove r-rscala

conda install $Y -c hute37 r-rscala


conda list r-rscala

```


