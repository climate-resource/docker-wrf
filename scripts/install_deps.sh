#!/usr/bin/env bash

set -x
set -e

# Set up the required ENV variables
# The current configuration uses GNU compilers
export DIR=/opt/wrf/libs
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS=-m64
export F77=gfortran
export FFLAGS=-m64
export NC_VERSION=4.1.3
MPICH_VERSION=3.2
ZLIB_VERSION=1.2.11
LIBPNG_VERSION=1.6.34
JASPER_VERSION=1.900.1

sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get install -y build-essential gfortran m4 csh git jq wget python

# Install pip and wrfconf
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
rm get-pip.py
sudo pip install wrfconf

# Install yq for parsing yaml files
wget -nv https://github.com/mikefarah/yq/releases/download/1.14.0/yq_linux_amd64
chmod +x yq_linux_amd64
sudo mv yq_linux_amd64 /usr/bin/yq

sudo chown root:ubuntu /opt && sudo chmod g+w /opt
mkdir -p $DIR
pushd $DIR

# Download the dependencies
# TODO: update these to the correct versions
wget -nv http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-$NC_VERSION.tar.gz
wget -nv http://www.mpich.org/static/downloads/$MPICH_VERSION/mpich-$MPICH_VERSION.tar.gz
wget -nv http://www.zlib.net/zlib-$ZLIB_VERSION.tar.gz
wget -nv ftp://ftp-osl.osuosl.org/pub/libpng/src/libpng16/libpng-$LIBPNG_VERSION.tar.gz
wget -nv http://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-$JASPER_VERSION.tar.gz

# Download and install netCDF
wget https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-$NC_VERSION.tar.gz
tar xzvf netcdf-$NC_VERSION.tar.gz
pushd netcdf-$NC_VERSION
./configure --prefix=$DIR/netcdf --disable-dap \
     --disable-netcdf-4 --disable-shared
make -j 8
make install
export PATH=$DIR/netcdf/bin:$PATH
export NETCDF=$DIR/netcdf
popd

# Install MPICH
tar xzvf mpich-$MPICH_VERSION.tar.gz
pushd mpich-$MPICH_VERSION
./configure --prefix=$DIR/mpich
make -j 8
make install
PATH=$DIR/mpich/bin:$PATH
popd

# Install zlib
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include

tar xzvf zlib-$ZLIB_VERSION.tar.gz
pushd zlib-$ZLIB_VERSION
./configure --prefix=$DIR/grib2
make -j 8
make install
popd

# Install libpng
tar xzvf libpng-$LIBPNG_VERSION.tar.gz
pushd libpng-$LIBPNG_VERSION
./configure --prefix=$DIR/grib2
make -j 8
make install
popd

# Install Jasper
tar xzvf jasper-$JASPER_VERSION.tar.gz     #or just .tar if no .gz present
pushd jasper-$JASPER_VERSION
./configure --prefix=$DIR/grib2
make -j 8
make install
popd

# Install NCL
wget https://www.earthsystemgrid.org/dataset/ncl.640.dap/file/ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz
sudo mkdir /usr/local/ncl-6.4.0
sudo tar -zxf ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz -C /usr/local/ncl-6.4.0
rm ncl_ncarg-6.4.0-Debian8.6_64bit_gnu492.tar.gz