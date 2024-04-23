#!/usr/bin/env bash
# Builds WRF and WPS using the prebuilt dependencies

set -x
set -e

# Setup
WRF_VERSION="${WRF_VERSION:-4.1.2}"
WPS_VERSION="${WPS_VERSION:-4.1}"
DIR=/opt/wrf/libs

# Link to the compiled dependencies
export PATH=$DIR/bin:$PATH
export LDFLAGS=-L$DIR/lib
export CPPFLAGS=-I$DIR/include
export CC=gcc
export CXX=g++
export FC=gfortran
export FCFLAGS="-m64  -fallow-argument-mismatch"
export F77=gfortran
export FFLAGS="-m64  -fallow-argument-mismatch"
export NETCDF=$DIR
export NETCDF4=1
export HDF5=$DIR
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export J="-j 8"

pushd $DIR/..

# Build WRF
if [ ! -f WRF-${WRF_VERSION}/run/real.exe ]; then
  wget -nv https://github.com/wrf-model/WRF/releases/download/v${WRF_VERSION}/v${WRF_VERSION}.tar.gz -O WRF-v${WRF_VERSION}.tar.gz
  tar -xzvf WRF-v${WRF_VERSION}.tar.gz
  pushd WRFV${WRF_VERSION} || exit
  echo "34\n1\n" | ./configure
  ./compile em_real
  popd
  ln -s WRFV${WRF_VERSION} WRF
fi

# Build WPS
if [ ! -f WPS-${WPS_VERSION}/wps.exe ]; then
  wget -nv https://github.com/wrf-model/WPS/archive/v${WPS_VERSION}.tar.gz -O WPS-v${WPS_VERSION}.tar.gz
  tar -xzvf WPS-v${WPS_VERSION}.tar.gz

  pushd WPSV${WPS_VERSION} || exit
  echo "1" | ./configure
  ./compile
  popd
  ln -s WPSV${WPS_VERSION} WPS
fi

rm *.tar.gz

