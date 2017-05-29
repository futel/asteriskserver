uci show | diff -u /etc/uci-firstboot - ; for f in $(find /overlay/upper -type f | sed 's|/overlay/upper/||' | grep -v etc/config | grep -v etc/uci-firstboot) ; do diff -uN /rom/$f /$f ; done
