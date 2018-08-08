#!/bin/bash
sudo apt-get update

# install openjdk 8
sudo apt-get install openjdk-8-jdk -y

# install tomcat 8
sudo apt-get install tomcat8 -y

# install PostGIS
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt xenial-pgdg main" >> /etc/apt/sources.list'
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -

sudo apt-get install postgresql-10 -y
sudo apt-get install postgresql-10-postgis-2.4 -y
sudo apt-get install postgresql-10-postgis-scripts -y
sudo apt-get install postgis -y

# configure PostGIS
sudo -u postgres psql -f /vagrant/db.gen

sudo apt-get install build-essential g++ cmake openscenegraph libopenscenegraph-dev libgmp3-dev libmpfr-dev -y
sudo apt-get install maven -y

# 코드로부터 빌드
git clone https://github.com/hgryoo/SFCGAL4J.git
# cd ~/SFCGAL4J/sfcgal4j-impl
# ./cppbuild.sh install
# cd ../
cd ~/SFCGAL4J
mvn clean install -U -DskipTests
cd ~/

git clone https://github.com/STEMLab/geotools-3d-extension.git
cd ~/geotools-3d-extension
mvn clean install -U -DskipTests
cd ~/

git clone https://github.com/STEMLab/geoserver-3d-extension.git
cd ~/geoserver-3d-extension
mvn clean install -U -DskipTests
cd ~/

git clone https://github.com/STEMLab/geoserver.git
cd ~/geoserver
git checkout geoserver3d
cd src
mvn clean install -U -DskipTests

cd web/app
mvn clean install -U -DskipTests
cd ~/

# deploy GeoServer
cd ~/geoserver/src/web/app/target
sudo cp -rf geoserver.war /var/lib/tomcat8/webapps/
sudo service tomcat8 restart

git clone https://github.com/hgryoo/SimpleWFSClient4Mago3D.git
cd ~/SimpleWFSClient4Mago3D
PGPASSWORD=postgis pg_restore --clean -h localhost -p 5432 -U postgis -d gisdb -v ./buildings.dump

curl -sL https://deb.nodesource.com/setup_10.x| sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install npm -y

git clone https://github.com/Gaia3D/mago3djs.git
cd ~/mago3djs
git checkout develop