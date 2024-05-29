#!/usr/bin/env bash
# Builds WRF and WPS using the prebuilt dependencies

set -xe

# Setup
WRF_VERSION="${WRF_VERSION:-4.5.1}"
WPS_VERSION="${WPS_VERSION:-4.5}"
DIR=/opt/venv

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
export NETCDF=$(nc-config --prefix)
export NETCDF4=1
export HDF5=$DIR
export JASPERLIB=$DIR/lib
export JASPERINC=$DIR/include
export J="-j 8"
export ARCH=$(uname -m)

# Build directory
cd /opt/wrf

# Build WRF
if [ ! -f WRF-${WRF_VERSION}/run/real.exe ]; then
  wget -nv https://github.com/wrf-model/WRF/releases/download/v${WRF_VERSION}/v${WRF_VERSION}.tar.gz -O WRF-v${WRF_VERSION}.tar.gz
  tar -xzvf WRF-v${WRF_VERSION}.tar.gz
  pushd WRFV${WRF_VERSION} || exit

  if [[ $ARCH == "aarch64" ]]; then
    echo "11\n1\n" | ./configure  # dmpar + gfortran + aarch64
  else
    echo "34\n1\n" | ./configure  # dmpar + gfortran + x86_64
  fi

  ./compile em_real
  popd
  ln -s WRFV${WRF_VERSION} WRF
fi

# Build WPS
if [ ! -f WPS-${WPS_VERSION}/wps.exe ]; then
  wget -nv https://github.com/wrf-model/WPS/archive/v${WPS_VERSION}.tar.gz -O WPS-v${WPS_VERSION}.tar.gz
  tar -xzvf WPS-v${WPS_VERSION}.tar.gz

  pushd WPS-${WPS_VERSION} || exit

  # Add some compiler options for aarch64 (based on x86_64)
  cat /opt/wrf/build/scripts/configure.aarch64 >> arch/configure.defaults

  echo "1" | ./configure # serial + gfortran
  ./compile
  popd
  ln -s WPS-${WPS_VERSION} WPS
fi

rm *.tar.gz

