## Build a Futel-specific Asterisk RPM for Rocky 8

# virtualbox setup

vagrant up
    
# create new rpm

# query rpm

    # get build dependencies
    dnf builddep ...src.rpm
    # rpm file list
    rpm -qlp /tmp/asterisk-18.4.0-1.fc35.1.src.rpm
    rpm -qlp --scripts
    # this does not extract config?
    rpm2cpio ... | cpio -idmv
    # extract srpm contents into rpmbuild tree
    rpm -Uvh rpmbuild/SRPMS/asterisk-18.8.0.futel.1-futel.1.el8.src.rpm 

fedora package
https://koji.fedoraproject.org/koji/buildinfo?buildID=1752809

# troubleshooting

    # up to including build
    rpmbuild -bc SPECS/asterisk.spec >bc.out 2>&1
    # install only, assume build done
    rpmbuild -bi --short-circuit SPECS/asterisk.spec >bc.out 2>&1
    # check file list
    rpmbuild -bl SPECS/asterisk.spec >bl.out 2>&1

    # output expanded spec
    rpmspec -P spec
