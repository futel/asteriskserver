## build asterisk-18.4.0-1.fc35.1 from rpm on centos 8

# build rpm from src rpm

    sudo dnf install -y rpmdevtools rpmlint

    # builds in ~/rpmbuild
    rpm -vv -Uvh asterisk-18.4.0-1.fc35.1.src.rpm

    yum install -y SDL-devel
    yum install -y alsa-lib-devel
    yum install -y bluez-libs-devel
    yum install -y dahdi-tools-devel
    yum install -y dahdi-tools-libs
    yum install -y doxygen
    yum install -y freetds-devel
    yum install -y graphviz
    yum install -y gsm-devel
    yum install -y gtk2-devel
    yum install -y ilbc-devel
    yum install -y latex2html
    yum install -y libcap-devel
    yum install -y libcurl-devel
    yum install -y libedit-devel
    yum install -y libical-devel
    yum install -y libjpeg-turbo-devel
    yum install -y libogg-devel
    yum install -y libpri-devel
    yum install -y libresample-devel
    yum install -y libsrtp-devel
    yum install -y libss7-devel
    yum install -y libtiff-devel
    yum install -y libtool-ltdl-devel
    yum install -y libvorbis-devel
    yum install -y lm_sensors-devel
    yum install -y mariadb-devel
    yum install -y neon-devel
    yum install -y net-snmp-devel
    yum install -y openldap-devel
    yum install -y perl
    yum install -y perl-generators
    yum install -y popt-devel
    yum install -y portaudio-devel
    yum install -y postgresql-devel
    yum install -y radcli-compat-devel
    yum install -y spandsp-devel
    yum install -y speex-devel
    yum install -y speexdsp-devel
    yum install -y unbound-devel
    yum install -y unixODBC-devel
    yum install -y uw-imap-devel
      
    # XXX
    yum install -y SDL_image-devel
    yum install -y corosynclib-devel
    yum install -y gmime-devel

    rpmbuild -bb --rebuild rpmbuild/SPECS/asterisk.spec
    ...
    
# create new rpm

https://www.redhat.com/sysadmin/create-rpm-package
https://superuser.com/questions/127976/install-src-rpm-package-on-red-hat-linux

    sudo dnf install -y rpmdevtools rpmlint
    rpmdev-setuptree
    ...
      
# query rpm

    rpm -qlp /tmp/asterisk-18.4.0-1.fc35.1.src.rpm
    rpm -qlp --scripts
    # this does not extract config
    rpm2cpio ... | cpio -idmv
      
# notes

https://koji.fedoraproject.org/koji/buildinfo?buildID=1752809
