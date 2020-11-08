#!/usr/bin/env bash

set -x
set -e

sudo apt update && sudo apt -y upgrade
sudo apt install -y build-essential gfortran m4 csh git jq wget aria2 imagemagick curl


# Set up the required ENV variables
# The current configuration uses GNU compilers
export DIR=/opt/wrf/libs
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS=-m64
export F77=gfortran
export FFLAGS=-m64
export NC_VERSION=4.7.0
export NC_FORTRAN_VERSION=4.4.5
MPICH_VERSION=3.2
ZLIB_VERSION=1.2.11
LIBPNG_VERSION=1.6.34
LIBCURL_VERSION=7.65.3
JASPER_VERSION=1.900.1
NUM_CORES=8


# Install pip and wrfconf
#wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
#bash Miniconda2-latest-Linux-x86_64.sh -b -p $HOME/miniconda
#rm Miniconda2-latest-Linux-x86_64.sh
#export PATH="$HOME/miniconda/bin:$PATH"
#pip install wrfconf
#pip install git+http://github.com/lewisjared/augurycli.git#egg=augurycli
#conda install -c conda-forge -y wrf-python matplotlib netCDF4 basemap basemap-data-hires
#conda clean --all -y

# Ensure the plotting works without a display
#mkdir -p ~/.config/matplotlib
#echo "backend : Agg" > ~/.config/matplotlib/matplotlibrc

# Install yq for parsing yaml files
if [ ! -f /usr/bin/yq ]; then
  wget -nv https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64
  chmod +x yq_linux_amd64
  sudo mv yq_linux_amd64 /usr/bin/yq
fi

#sudo chown root:ubuntu /opt && sudo chmod g+w /opt
sudo mkdir -p $DIR/src
sudo chown ubuntu:ubuntu -R /opt/wrf
pushd $DIR/src

export LDFLAGS=-L$DIR/lib
export CPPFLAGS=-I$DIR/include
export PATH=$DIR/bin:$PATH
export NETCDF=$DIR


#Install libcurl
if [ ! -f $DIR/lib/libcurl.a ]; then
  wget -nv https://curl.haxx.se/download/curl-$LIBCURL_VERSION.tar.gz
  tar xzvf curl-$LIBCURL_VERSION.tar.gz
  pushd curl-$LIBCURL_VERSION
  ./configure --prefix=$DIR
  make -j $NUM_CORES
  make install
  popd
fi

#Install zlib
if [ ! -f $DIR/lib/libz.a ]; then
  wget -nv -N http://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz
  tar xzvf zlib-$ZLIB_VERSION.tar.gz
  pushd zlib-$ZLIB_VERSION
  ./configure --prefix=$DIR
  make -j $NUM_CORES
  make install
  popd
fi

# Install libpng
if [ ! -f $DIR/lib/libpng.a ]; then
  wget -nv -N ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-$LIBPNG_VERSION.tar.gz
  tar xzvf libpng-$LIBPNG_VERSION.tar.gz
  pushd libpng-$LIBPNG_VERSION
  ./configure --prefix=$DIR
  make -j $NUM_CORES
  make install
  popd
fi

# Install Jasper
if [ ! -f $DIR/lib/libjasper.a ]; then
  wget -nv -N http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-$JASPER_VERSION.tar.gz
  tar xzvf jasper-$JASPER_VERSION.tar.gz     #or just .tar if no .gz present
  pushd jasper-$JASPER_VERSION
  ./configure --prefix=$DIR
  make -j $NUM_CORES
  make install
  popd
fi

# Install MPICH
if [ ! -f $DIR/lib/libmpi.a ]; then
  wget -nv -N http://www.mpich.org/static/downloads/$MPICH_VERSION/mpich-$MPICH_VERSION.tar.gz
  tar xzvf mpich-$MPICH_VERSION.tar.gz
  pushd mpich-$MPICH_VERSION
  ./configure --prefix=$DIR
  make -j $NUM_CORES
  make install
  popd
fi

#Install libhdf5
if [ ! -f $DIR/lib/libhdf5.a ]; then
  wget -nv -N https://support.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.10.5.tar.gz
  tar xzvf hdf5-1.10.5.tar.gz
  pushd hdf5-1.10.5
  ./configure --prefix=$DIR --enable-fortran
  make -j $NUM_CORES
  make install
  popd
fi

# Download and install netCDF
if [ ! -f $DIR/lib/libnetcdf.a ]; then
  wget -nv -N https://github.com/Unidata/netcdf-c/archive/v$NC_VERSION.tar.gz -O netcdf-c-$NC_VERSION.tar.gz
  tar xzvf netcdf-c-$NC_VERSION.tar.gz
  pushd netcdf-c-$NC_VERSION
  ./configure --prefix=$DIR --disable-dap --enable-netcdf4
  make -j $NUM_CORES
  make install
  popd
fi

# Install netcdf-fortran
if [ ! -f $DIR/lib/libnetcdff.a ]; then
  wget -nv -N https://github.com/Unidata/netcdf-fortran/archive/v$NC_FORTRAN_VERSION.tar.gz -O netcdf-fortran-$NC_FORTRAN_VERSION.tar.gz
  tar xzvf netcdf-fortran-$NC_FORTRAN_VERSION.tar.gz
  pushd netcdf-fortran-$NC_FORTRAN_VERSION
  ./configure --prefix=$DIR
  make -j $NUM_CORES
  make install
  popd
fi


rm ./*.tar.gz
