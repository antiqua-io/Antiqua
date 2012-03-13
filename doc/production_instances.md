# Production Instances

Application instances that are for production use and are
mission-critical are typically deployed to 64bit environments.
Application servers and datastore servers are separate in this case. The
`bash` scripts below are used for bootstrapping their respective server
types.

## app_server_install.bash

```
#!/bin/bash

## README
# To run this script
# => scp it to the server
# => run `sudo bash install.bash`

# Preparations
add-apt-repository -y ppa:chris-lea/node.js # Node.js Prep
apt-get -y update                           # Start with a fresh update

# Required Packages
apt-get -y install python-software-properties libssl-dev git-core pkg-config build-essential curl gcc g++ openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion traceroute

# MongoDB Nginx Redis Node.js
apt-get -y install nginx nodejs-dev nodejs

# Nginx Setup
mkdir -p /var/www         # common deploy-to location for our code
mkdir -p /etc/nginx/certs # place SSL certs here

# NPM
curl http://npmjs.org/install.sh | sudo sh

# RVM
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
adduser ubuntu rvm
echo "" > ~/.rvmrc                                 # clean out this file in case it is a rerun
echo "rvm_install_on_use_flag=1" >> ~/.rvmrc       # install known rubies automatically on use
echo "rvm_gemset_create_on_use_flag=1" >> ~/.rvmrc # create gemsets automatically on use
source /etc/profile.d/rvm.sh                       # setup system-wide RVM
source ~/.profile                                  # reload user environment profile
rvm install 1.9.3                                  # install necessary ruby
rvm use 1.9.3 --default                            # use necessary ruby by default

# Finishing Up
apt-get -y autoremove
apt-get -y clean
apt-get -y autoclean
```

## datastore_server_install.bash

Datastore servers still include node.js/npm and rvm with ruby-1.9.3-p125
for use in debugging scenarios.

```
#!/bin/bash

## README
# To run this script
# => scp it to the server
# => run `sudo bash install.bash`

# Preparations
echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | tee -a /etc/apt/sources.list # MongoDB Prep
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10                                                 # MongoDB Prep
add-apt-repository -y ppa:chris-lea/node.js                                                                  # Node.js Prep
apt-get -y update                                                                                            # Start with a fresh update

# Required Packages
apt-get -y install python-software-properties libssl-dev git-core pkg-config build-essential curl gcc g++ openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion traceroute

# MongoDB Nginx Redis Node.js
apt-get -y install mongodb-10gen redis-server nodejs-dev nodejs

# NPM
curl http://npmjs.org/install.sh | sudo sh

# RVM
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
adduser ubuntu rvm
echo "" > ~/.rvmrc                                 # clean out this file in case it is a rerun
echo "rvm_install_on_use_flag=1" >> ~/.rvmrc       # install known rubies automatically on use
echo "rvm_gemset_create_on_use_flag=1" >> ~/.rvmrc # create gemsets automatically on use
source /etc/profile.d/rvm.sh                       # setup system-wide RVM
source ~/.profile                                  # reload user environment profile
rvm install 1.9.3                                  # install necessary ruby
rvm use 1.9.3 --default                            # use necessary ruby by default

# Finishing Up
apt-get -y autoremove
apt-get -y clean
apt-get -y autoclean
```
