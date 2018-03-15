#!/usr/bin/env bash
# Builds WRF and WPS using the prebuilt dependencies

set -x

# Setup
WRF_VERSION=3.8.1
DIR=/opt/wrf/libs

# Link to the compiled dependencies
export PATH=$DIR/netcdf/bin:$DIR/mpich/bin:$PATH
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS=-m64
export F77=gfortran
export FFLAGS=-m64
export NETCDF=$DIR/netcdf
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include

pushd $DIR/..

# Download the source
wget -nv http://www2.mmm.ucar.edu/wrf/src/WRFV${WRF_VERSION}.TAR.gz
wget -nv http://www2.mmm.ucar.edu/wrf/src/WPSV${WRF_VERSION}.TAR.gz

# Build WRF
tar -xzvf WRFV${WRF_VERSION}.TAR.gz
pushd WRFV3
echo "34\n1\n" | ./configure
./compile em_real -j8
./compile em_real -j8 # Not sure why i need to do it twice, but I do..
ls -ls *.exe
popd

# Build WPS
tar -xzvf WPSV${WRF_VERSION}.TAR.gz
pushd WPS
echo "1" | ./configure
./compile
ls -ls *.exe
popd

rm *.tar.gz