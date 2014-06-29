# A CentOS 6 Vagrant Box with Python 3 + Django + PostgreSQL + Nginx +  Gunicorn

This repository contains a CentOS 6.5 box for Vagrant.  Python 3.3 and PostgreSQL 9.2 are enabled by using Red Hat Software Collections (SCL).  The Vagrant config uses a bootstrap.sh script meant to illustrate steps for getting a development environment in a self-contained virtualenv directory.

Getting started...

* install virtualbox https://www.virtualbox.org/wiki/Downloads
* install vagrant http://www.vagrantup.com/downloads
* install git http://git-scm.com/downloads
* create and add a public SSH key to your github account https://github.com/settings/ssh

```
$ git clone git@github.com:00gavin/vagrant-centos6-python3.git
$ cd vagrant-centos6-python3
$ vagrant up
$ vagrant ssh
$ scl enable python33 postgresql92 bash
$ cd /usr/local/dev && source bin/activate
```

Trying out Django...

``` bash
$ django-admin.py startproject mysite && cd mysite
$ cp ../settings-psql.py mysite/settings.py
$ python manage.py syncdb
$ python manage.py runserver 8081
browse http://127.0.0.1:8080/
when done, hit ctrl+c to terminate process
```

Trying out mod_wsgi...

```
$ mod_wsgi-express start-server --port 8081
browse http://127.0.0.1:8081/
when done, hit ctrl+c to terminate process
$ python manage.py runmodwsgi --port 8081
browse http://127.0.0.1:8080/
when done, hit ctrl+c to terminate process
```

Trying out Django with Green Unicorn...

```
$ gunicorn -c /usr/local/dev/gunicorn_config.py mysite.wsgi
browse http://127.0.0.1:8080/
when done, hit ctrl+c to terminate process
```

Shutting it down...

```
$ deactivate
$ exit
$ exit
$ vagrant destroy
```

Note that there are commands for alternative mysql or apache in the bootstrap file.

