#!/bin/bash
#set -e Somehow the wget command ends with 4
set -x

ROOT_DIR=$PWD
ART_DIR=$ROOT_DIR/artifact
DEP_DIR=$ART_DIR/dependencies
PACK_DIR=$DEP_DIR/apt-packages
PIP_DIR=$DEP_DIR/pip-packages
FIMDP_TAG=next

#############################
### Download apt-packages ###
#############################
PACK_URIS=$DEP_DIR/packages.uri

mkdir -p $PACK_DIR

# Get URIs of the needed packages
sudo apt-get update
apt-get install --print-uris libgmp-dev libglpk-dev libhwloc-dev z3 libboost-all-dev libeigen3-dev libginac-dev libpython3-dev automake jupyter graphviz python3-pip | grep -oP "(?<=').*(?=')" > $PACK_URIS

# Download the needed packages
cd $PACK_DIR
wget -i $PACK_URIS
cd $ROOT_DIR

#######################################
### Download requested pip packages ###
#######################################
# Install pip3
sudo dpkg -i $PACK_DIR/*pip*.deb
# Download Python packages
pip3 download -d $PIP_DIR jupyterlab pytest pytest-runner pandas numpy matplotlib scipy ipython folium networkx

####################################
### Download Storm+Carl and Spot ###
####################################
wget -O $DEP_DIR/spot-2.9.4.tar.gz http://www.lrde.epita.fr/dload/spot/spot-2.9.4.tar.gz
wget -O $DEP_DIR/carl.zip https://github.com/smtrat/carl/archive/master14.zip
wget -O $DEP_DIR/pycarl.zip https://github.com/moves-rwth/pycarl/archive/master.zip
wget -O $DEP_DIR/storm.zip https://github.com/moves-rwth/storm/archive/stable.zip
wget -O $DEP_DIR/stormpy.zip https://github.com/moves-rwth/stormpy/archive/master.zip

# Copy Storm adjustments
cp -r storm_3rdparty_CMakeLists.txt StormEigen $DEP_DIR

#################################
### Download FiMDP tool suite ###
#################################
wget -O $ART_DIR/fimdp.zip https://github.com/FiMDP/FiMDP/archive/$FIMDP_TAG.zip
wget -O $ART_DIR/fimdpenv.zip https://github.com/FiMDP/FiMDPEnv/archive/$FIMDP_TAG.zip
#wget -O $ART_DIR/tutorials.zip https://github.com/FiMDP/tutorials/archive/$FIMDP_TAG.zip
FIMDP_TAG=alpha
wget -O $ART_DIR/evaluation.zip https://github.com/FiMDP/FiMDP-Evaluation/archive/$FIMDP_TAG.zip

# Copy installation scripts
cp install_carl.sh install_storm.sh install_spot.sh $DEP_DIR
cp install_dependencies.sh install_fimdp.sh $ART_DIR

# Copy README.md
cp README_artifact.md $ART_DIR/README.md

cd $ROOT_DIR 
zip fimdp-artifact.zip artifact/* -r