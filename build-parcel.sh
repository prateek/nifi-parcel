#!/bin/bash
set -e

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <nifi-assembly-bin.tar.gz>"
  exit 1
fi

NIFI_TAR_PATH=$1
NIFI_TAR_NAME=$(basename $NIFI_TAR_PATH)

VALIDATOR_DIR=${VALIDATOR_DIR:-~/trash/cm_ext}
POINT_VERSION=${POINT_VERSION:-1}

SRC_DIR=${SRC_DIR:-parcel-src}
BUILD_DIR=${BUILD_DIR:-build-parcel}

PARCEL_NAME=$(echo NIFI-0.0.${POINT_VERSION}.nifi.p0.${POINT_VERSION})
SHORT_VERSION=$(echo 0.0.${POINT_VERSION})
FULL_VERSION=$(echo ${SHORT_VERSION}.nifi.p0.${POINT_VERSION})

# Make Build Directory
if [ -d $BUILD_DIR ];
then
  rm -rf $BUILD_DIR
fi

# Make directory
mkdir $BUILD_DIR

# NiFi Meta
cp -r $SRC_DIR $BUILD_DIR/$PARCEL_NAME

# Create Copy
cp $NIFI_TAR_PATH $BUILD_DIR/$PARCEL_NAME
cd $BUILD_DIR/$PARCEL_NAME
tar xvfz $NIFI_TAR_NAME
rm -f $NIFI_TAR_NAME
mv nifi-*/* .
rmdir nifi-*
chmod -R 755 ./lib ./conf

# move into BUILD_DIR
cd ..

for file in `ls $PARCEL_NAME/meta/**`
do
  sed -i "" "s/<VERSION-FULL>/$FULL_VERSION/g"     $file
  sed -i "" "s/<VERSION-SHORT>/${SHORT_VERSION}/g" $file
done

# validate directory
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -d $PARCEL_NAME

# http://superuser.com/questions/61185/why-do-i-get-files-like-foo-in-my-tarball-on-os-x
export COPYFILE_DISABLE=true

# create parcel
tar zcvf ${PARCEL_NAME}-el6.parcel ${PARCEL_NAME}

# validate parcel
java -jar $VALIDATOR_DIR/validator/target/validator.jar \
  -f ${PARCEL_NAME}-el6.parcel

# create manifest
$VALIDATOR_DIR/make_manifest/make_manifest.py
