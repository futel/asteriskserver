#%%global           makeargs        DEBUG= OPTIMIZE= DESTDIR=%%{buildroot} ASTVARRUNDIR=%%{astvarrundir} ASTDATADIR=%%{_datadir}/asterisk ASTVARLIBDIR=%%{_datadir}/asterisk ASTDBDIR=%%{_localstatedir}/spool/asterisk NOISY_BUILD=1
%global           makeargs        DESTDIR=%{buildroot} NOISY_BUILD=1

Name:             asterisk
Version:          18.8.0
Release:          futel.1%{?dist}
Summary:          Futel-specific build of Asterisk PBX
License:          GPLv2

Source0:          asterisk-18.8.0.futel.1.tar.gz
Source1:          menuselect.sh

BuildRequires: autoconf
BuildRequires: automake
BuildRequires: gcc
BuildRequires: gcc-c++
BuildRequires: ncurses
BuildRequires: perl
BuildRequires: openssl-devel
BuildRequires: newt-devel
BuildRequires: ncurses-devel
BuildRequires: libcap-devel
# BuildRequires: gtk2-devel
BuildRequires: libsrtp-devel
BuildRequires: perl-interpreter
BuildRequires: perl-generators
BuildRequires: popt-devel
BuildRequires: systemd
BuildRequires: kernel-headers
# BuildRequires: gmime-devel
# BuildRequires: doxygen
# BuildRequires: graphviz
BuildRequires: libxml2-devel
# BuildRequires: latex2html
# BuildRequires: neon-devel
# BuildRequires: libical-devel
# BuildRequires: libxml2-devel
# BuildRequires: speex-devel >= 1.2
# BuildRequires: speexdsp-devel >= 1.2
BuildRequires: libogg-devel
BuildRequires: libvorbis-devel
BuildRequires: gsm-devel
BuildRequires: SDL-devel
# BuildRequires: SDL_image-devel
BuildRequires: libedit-devel
BuildRequires: ilbc-devel
BuildRequires: libuuid-devel
# BuildRequires: unbound-devel
# BuildRequires: corosynclib-devel
BuildRequires: alsa-lib-devel
BuildRequires: libcurl-devel
BuildRequires: dahdi-tools-devel >= 2.0.0
BuildRequires: dahdi-tools-libs >= 2.0.0
BuildRequires: libpri-devel >= 1.4.12
BuildRequires: libss7-devel >= 1.0.1
BuildRequires: spandsp-devel >= 0.0.5-0.1.pre4
BuildRequires: libtiff-devel
BuildRequires: libjpeg-turbo-devel
BuildRequires: lua-devel
BuildRequires: jack-audio-connection-kit-devel
BuildRequires: libresample-devel
BuildRequires: bluez-libs-devel
BuildRequires: libtool-ltdl-devel
BuildRequires: portaudio-devel >= 19
BuildRequires: sqlite-devel
BuildRequires: freetds-devel
# BuildRequires: mISDN-devel
# BuildRequires: openldap-devel
# BuildRequires: mariadb-devel
# BuildRequires: mariadb-connector-c-devel
# BuildRequires: libtool-ltdl-devel
# BuildRequires: unixODBC-devel
# BuildRequires: postgresql-devel
# BuildRequires: libpq-devel
# BuildRequires: freeradius-client-devel
# BuildRequires: radcli-compat-devel
BuildRequires: net-snmp-devel
BuildRequires: lm_sensors-devel
# BuildRequires: uw-imap-devel
BuildRequires: jansson-devel
BuildRequires: libgcrypt
BuildRequires: make

Requires: /usr/bin/sox
Requires(post):   systemd-units
Requires(post):   systemd-sysv

# This macro causes a build error?
%define debug_package %{nil}
# Linter rejections cause failure. The fedora rpm has a patch to fix this.
%define __os_install_post %{nil}

%description
Futel-specific build of Asterisk PBX from https://www.asterisk.org/. Loosely based on asterisk-18.4.0-1.fc35.1.src.rpm.

%prep
%setup -q
cp %{S:1} menuselect.sh
# If we start building the bundled pjproject, that needs prep here,

%build
# prob should match the fedora build with --with-*-bundled etc
%configure
make menuselect.makeopts
./menuselect.sh
%make_build %{makeargs}

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_localstatedir}/lib/asterisk
mkdir -p %{buildroot}%{_localstatedir}/run/asterisk
mkdir -p %{buildroot}%{_initddir}
mkdir -p %{buildroot}/etc/sysconfig
make install %{makeargs}
# Fedora rpm installs asterisk.service instead of running make config.
make config %{makeargs}

# Tasks currently handled in our ansible recipes:
#create asterisk user and group
#copy service config
#make asterisk log archive directory
#change file ownership
#enable but do not yet start asterisk
#%post
#if [ $1 -eq 1 ] ; then
#	/bin/systemctl daemon-reload >/dev/null 2>&1 || :
#fi

# We are assuming asterisk user and group have been created. Fedora rpm
# creates them here.
#%%pre ...

%files

%{_libdir}/libasteriskssl.so
%{_libdir}/libasteriskssl.so.1
%{_libdir}/libasteriskpj.so
%{_libdir}/libasteriskpj.so.2
%{_libdir}/asterisk
%{_sbindir}/astcanary
%{_sbindir}/astdb2bdb
%{_sbindir}/astdb2sqlite3
%{_sbindir}/asterisk
%{_sbindir}/astgenkey
%{_sbindir}/astversion
%{_sbindir}/autosupport
%{_sbindir}/rasterisk
%{_sbindir}/safe_asterisk

%attr(0750,asterisk,asterisk) %dir %{_sysconfdir}/asterisk
# %%config(noreplace) %%{_sysconfdir}/logrotate.d/asterisk

%attr(0750,asterisk,asterisk) %{_localstatedir}/lib/asterisk
%attr(0755,asterisk,asterisk) %dir %{_localstatedir}/run/asterisk
%attr(0750,asterisk,asterisk) %dir %{_localstatedir}/log/asterisk
%attr(0750,asterisk,asterisk) %dir %{_localstatedir}/log/asterisk/cdr-csv
%attr(0750,asterisk,asterisk) %dir %{_localstatedir}/log/asterisk/cdr-custom
%attr(0750,asterisk,asterisk) %dir %{_localstatedir}/spool/asterisk
%attr(0770,asterisk,asterisk) %dir %{_localstatedir}/spool/asterisk/monitor
# XXX The asterisk build on prod has this, it is the call file spool.
#%%attr(0770,asterisk,asterisk) %%dir %%{_localstatedir}/spool/asterisk/outgoing
%attr(0750,asterisk,asterisk) %dir %{_localstatedir}/spool/asterisk/tmp
%attr(0750,asterisk,asterisk) %dir %{_localstatedir}/spool/asterisk/voicemail

%{_mandir}/man8/astdb2bdb.8*
%{_mandir}/man8/astdb2sqlite3.8*
%{_mandir}/man8/asterisk.8*
%{_mandir}/man8/astgenkey.8*
%{_mandir}/man8/autosupport.8*
%{_mandir}/man8/safe_asterisk.8*

# We should be preventing this from being built,
# there's probably a make arg to add?
%{_datadir}/dahdi/span_config.d/40-asterisk

%{_initddir}/asterisk
/etc/sysconfig/asterisk

# %%files iax2
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/iax.conf
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/iaxprov.conf

# %%files lua
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/extensions.lua

# %%files pjsip
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/pjsip.conf
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/pjproject.conf
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/pjsip_notify.conf
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/pjsip_wizard.conf

# %%files sip
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/sip.conf
#%%attr(0640,asterisk,asterisk) %%config(noreplace) %%{_sysconfdir}/asterisk/sip_notify.conf

%changelog
* Sun Dec  5 2021 operator
- first
