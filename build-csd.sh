#!/bin/bash
set -e

if [[ $# -ne 0 ]]; then
  echo "Usage: $0"
  exit 1
fi

VALIDATOR_DIR=${VALIDATOR_DIR:-~/trash/cm_ext}
POINT_VERSION=${POINT_VERSION:-1}

SRC_DIR=${SRC_DIR:-csd-src}
BUILD_DIR=${BUILD_DIR:-build-csd}
#
# validate directory
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -s $SRC_DIR/descriptor/service.sdl

# Make Build Directory
if [ -d $BUILD_DIR ];
then
  rm -rf $BUILD_DIR
fi

# Make directory
mkdir $BUILD_DIR
cd $SRC_DIR
jar -cvf NIFI-1.0.jar *
cd ..
mv $SRC_DIR/NIFI-1.0.jar $BUILD_DIR/.

