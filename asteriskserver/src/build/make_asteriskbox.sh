#!/usr/bin/env bash
# bootstrap from centos6_32_baseinstall

set -x # print commands as executed
BUILDDIR=/vagrant/src/build

conf_version=$1

# # Are we in a virtualbox?  Should just have vagrant send this as an arg.
# # Wasn't able to pass the value of config.vm.provider, but could just set it
# # manually.
# virtualbox=false
# dmidecode | grep -q 'Product Name:.*VirtualBox' && virtualbox=true

#install libresample and jack
pushd /tmp/
tar xzvf /vagrant/src/libresample_0.1.3.orig.tar.gz
pushd libresample-0.1.3
./configure
make && make install
popd

pushd /tmp/
tar xjvf /vagrant/src/jack-1.9.10.tar.bz2
pushd jack-1.9.10
./waf configure --alsa
./waf build
./waf install
popd

# install pyst
cd /tmp
tar xvf /vagrant/src/pyst-0.6.50.tar.gz
cd pyst-0.6.50
python setup.py install --prefix=/usr/local
ln -s /usr/local/lib/python2.6/site-packages/asterisk/ /usr/lib/python2.6/site-packages/

# run festival in rc.local
# XXX need a real daemon or supervisord, this goes down
# XXX this is not exactly safe
echo "su -s /bin/bash nobody -c '/usr/bin/festival --server &'" >> /etc/rc.d/rc.local

# build, install asterisk from source
mkdir /opt/asterisk
chown asterisk:asterisk /opt/asterisk
cd /tmp
cp /vagrant/src/asterisk-11-current.tar.gz . # to get around perm issues
sudo -u asterisk tar xvf asterisk-11-current.tar.gz
cd asterisk-11.5.1

# # XXX if 64bit, --libdir=/usr/lib64, but must be root to install?
# #     maybe we can put libdir within the prefix?
# if [ $virtualbox = true ]; then
#     # virtualbox on ubuntu thinkpad
#     # http://gentoo-what-did-you-say.blogspot.com/2011/07/finding-cpu-flags-using-gcc.html
#     CFLAGS=-march=core2
# fi

#we need resample for the app_jack module which lets us interface with the jack audio connection toolkit
sudo -u asterisk ./configure --with-resample=/tmp/libresample-0.1.3/ --prefix=/opt/asterisk --exec_prefix=/opt/asterisk  #CFLAGS=$CFLAGS

# do some things that make menuselect does
# XXX what a crock!  Some of these may be superstition.
sudo -u asterisk make menuselect.makeopts menuselect-tree
sudo -u asterisk make menuselect/cmenuselect menuselect/nmenuselect menuselect/gmenuselect
sudo -u asterisk rm -f channels/h323/Makefile.ast main/asterisk

# create files normally done with make menuselect
# XXX need to pare these files down
#     alternative, create a smaller menuselect file starting with:
#     sudo -u asterisk menuselect/menuselect --enable-all menuselect.makeopts
# the virtualbox version is used for virtualbox and digital ocean
/bin/cp -f /vagrant/src/menuselect.makeopts.virtualbox ./menuselect.makeopts
# virtualbox, digital ocean, and probably all virtual providers disbable native
# optimizations
sudo -u asterisk menuselect/menuselect --disable BUILD_NATIVE menuselect.makeopts
/bin/cp -f /vagrant/src/menuselect.makedeps ./menuselect.makedeps
/bin/cp -f /vagrant/src/menuselect-tree ./menuselect-tree

sudo -u asterisk make

# XXX if we were 64 bit, we must be root to do this because of libdir?
#     do we need to chown back to asterisk in that case?
sudo -u asterisk make install
# XXX want to pare this down
sudo -u asterisk make samples

make config # as root

$BUILDDIR/update_asteriskbox.sh $conf_version

mkdir /opt/asterisk/var/log/asterisk/old
chown asterisk: /opt/asterisk/var/log/asterisk/old
cp -f /vagrant/src/logrotate/logrotate.d/asterisk /etc/logrotate.d/asterisk

service asterisk restart

cp -rf /vagrant/src/logwatch/* /etc/logwatch/
cp -f /vagrant/src/logwatch/conf/logwatch.conf /usr/share/logwatch/default.conf/logwatch.conf
# write the config files that are local or have secrets
cp -f /vagrant/conf/logwatch.conf.$conf_version /etc/logwatch/conf/logwatch.conf

# install mpg123 for mp3 playback
# docs claim this is not needed but I am yet to see it work without
cd /tmp
tar xvf /vagrant/src/mpg123-1.22.2.tar.bz2
cd mpg123-1.22.2
./configure
make && make install

#make ldconf see locally installed libs
echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local.conf
/sbin/ldconfig

# install asterisk event listener
mkdir -p /opt/futel/src
cp /vagrant/src/eventlistener.py /opt/futel/src
# write the config files that are local or have secrets
cp /vagrant/conf/eventlistenerconf.$conf_version.py /opt/futel/src/eventlistenerconf.py
chown -R asterisk:asterisk /opt/futel

# run eventlistnener in rc.local
# XXX need a real daemon or supervisord, this goes down
echo "su -s /bin/bash nobody -c /opt/futel/src/eventlistener.py" >> /etc/rc.d/rc.local

# run rc.local now
nohup /etc/rc.d/rc.local &

# let's make pd for toorcamp/houseguest
/vagrant/src/build/make_pd.sh

# TODO this will be off by default for now. currently 240MB
#	uncomment for testing or for DO build
#cd /tmp
#git clone https://github.com/lboom/futel-assets
#cd futel-assets/
#cp -rf phonetrips /opt/asterisk/var/lib/asterisk/.
#chown -R asterisk: /opt/asterisk/var/lib/asterisk/phonetrips/
