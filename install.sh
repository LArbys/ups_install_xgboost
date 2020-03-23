#!/bin/bash

XGBOOST_VERSION=v1.0.2
UPS_VERSION=v1_0_2
FLAVOR=Linux64bit+3.10-2.17
PRODUCT_DIR=/uboone/app/users/tmw/ups_dev/products

INSTALL_DIR=$PRODUCT_DIR/xgboost/${UPS_VERSION}/${FLAVOR}/

# setup cmake
setup cmake v3_13_2 -q e17:prof

# setup scipy
setup scipy v1_1_0 -q e17:openblas:p2714b:prof

# get source and make build directory
mkdir -p $INSTALL_DIR
mkdir build
git clone --recursive https://github.com/dmlc/xgboost.git xgboost_src
cd xgboost_src
git checkout -b $XGBOOST_VERSION $XGBOOST_VERSION
git submodule init
git submodule update

# build C++ libraries
cd ../build/
cmake ../xgboost_src -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR/
make install -j4

# build python libraries
cd ../xgboost_src/python-package
mkdir -p $INSTALL_DIR/lib/python2.7/site-packages
export PYTHONPATH=$INSTALL_DIR/lib/python2.7/site-packages:$PYTHONPATH
python setup.py install --prefix=$INSTALL_DIR

# position the ups files
mkdir -p $INSTALL_DIR/ups
mkdir -p $PRODUCT_DIR/xgboost/${UPS_VERSION}.version
cp ups $INSTALL_DIR/ups/
cp Linux64bit+3.10-2.17_e17_prof $PRODUCT_DIR/xgboost/${UPS_VERSION}.version/
