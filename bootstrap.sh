#!/bin/sh

# create our development directory
DEVDIR=/usr/local/dev
mkdir $DEVDIR
rsync /vagrant/* $DEVDIR

# enable the Extra Packages for Enterprise Linux (EPEL) repository
echo "Enabling Extra Packages for Enterprise Linux (EPEL) repository..."
yum -y -q install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# enable Red Hat Software Collections (SCL) for the latest python and postgresql and more
echo "Enabling Red Hat Software Collections (SCL) repository..."
yum -y -q install centos-release-SCL

# install Nginx
echo "Installing Nginx..."
yum -y -q install nginx
mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.orig
mv $DEVDIR/nginx-dev.conf /etc/nginx/conf.d/
service nginx start
chkconfig nginx on

# install apache with a simple proxy config
#echo "Installing Apache..."
#yum -y -q install httpd mod_ssl httpd-devel
#mv $DEVDIR/apache-dev.conf /etc/httpd/conf.d/
#service httpd start
#chkconfig httpd on

# install postgresql 9, set the environment paths and create a dev database
# note that we set paths because the scl command is not script or su friendly
echo "Installing PostgreSQL 9..."
yum -y -q install postgresql92
service postgresql92-postgresql initdb
service postgresql92-postgresql start
chkconfig postgresql92-postgresql on
source /opt/rh/postgresql92/enable
cd /
su postgres -c 'createuser vagrant'
su postgres -c 'createdb dev --owner vagrant'

# install python 3 and add it to the environment paths
echo "Installing Python 3..."
yum -y -q install python33 python33-devel python33-python-virtualenv python33-python-psycopg2
source /opt/rh/python33/enable

# initialize the directory to contain our python packages
echo "Building virtualenv containing Python modules..."
virtualenv -q --system-site-packages $DEVDIR
cd $DEVDIR && source bin/activate
pip install ipython gunicorn django mod_wsgi --quiet

# a mysql connector that reportedly works with python 3 and django
# see http://dev.mysql.com/doc/relnotes/connector-python/en/news-1-1-5.html
#pip install mysql-connector-python --quiet
#yum -y -q install mysql mysql-server
#service mysqld start
#chkconfig mysqld on
#echo "create database dev;" |mysql
#echo "create user vagrant@localhost" |mysql
#echo "grant all on dev.* to vagrant@localhost" |mysql
#echo "flush privileges" |mysql

# fix the file permissions
chown -R vagrant.vagrant $DEVDIR

# set a login message and done
mv -f $DEVDIR/motd /etc/
echo "DONE"
