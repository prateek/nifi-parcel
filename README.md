NiFi Parcel
===========

This repository provides a parcel(https://github.com/cloudera/cm_ext) to install Apache NiFi as a service usable by Cloudera Manager.

# Install Steps
0. Install Prerequisites: `cloudera/cm_ext`
```sh
cd /tmp
git clone https://github.com/cloudera/cm_ext
cd cm_ext/validator
mvn install
```

1. Create parcel & CSD:
```sh
$ cd /tmp
# First, create NiFi package
$ git clone http://github.com/apache/nifi
$ cd nifi
$ mvn clean install
$ cd /tmp
$ git clone http://github.com/prateek/nifi-parcel
$ cd nifi-parcel
$ POINT_VERSION=5 VALIDATOR_DIR=/tmp/cm_ext ./build-parcel.sh /tmp/nifi/nifi-assembly/target/nifi-*-SNAPSHOT-bin.tar.gz
$ VALIDATOR_DIR=/tmp/cm_ext ./build-csd.sh
```

2. Serve Parcel using Python
```sh
$ cd build-parcel
$ python -m SimpleHTTPServer 14641
# navigate to Cloudera Manager -> Parcels -> Edit Settings
# Add fqdn:14641 to list of urls
# install the NIFI parcel
```

4. Move CSD to Cloudera Manager's CSD Repo
```sh
# transfer build-csd/NIFI-1.0.jar to CM's host
$ cp NIFI-1.0.jar /opt/cloudera/csd
$ mkdir /opt/cloudera/csd/NIFI-1.0
$ cp NIFI-1.0.jar /opt/cloudera/csd/NIFI-1.0
$ cd /opt/cloudera/csd/NIFI-1.0
$ jar xvf NIFI-1.0.jar
$ rm -f NIFI-1.0.jar
$ sudo service cloudera-scm-server restart
# Wait a min, go to Cloudera Manager -> Add a Service -> NiFi
```

## Pending items
- Currently `NiFi` runs under the `root` user
- Expose config options under Cloudera Manager
  - Conf folder from parcels is used, this needs to be migrated to ConfigWriter
- Expose metrics from NiFi
