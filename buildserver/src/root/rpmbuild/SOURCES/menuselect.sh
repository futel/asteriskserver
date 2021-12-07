#!/bin/sh

# These options are an attempt at a minimal build. The normal way to build
# is to run the interactive menuselect once and then use that
# menselect.makeopts as a build config file? We might be missing some
# dependency resolution by using menuselect with arguments instead.
# Anyway, some of these are probably superstitious.
# It would be nice to disable more of:
# MENUSELECT_PBX
# MENUSELECT_FUNCS
# MENUSELECT_FORMATS
# MENUSELECT_CODECS
menuselect/menuselect \
    --disable-category MENUSELECT_TESTS \
    --disable-category MENUSELECT_CEL \
    --disable-category MENUSELECT_CFLAGS \
    --disable-category MENUSELECT_AGIS \
    --disable-category MENUSELECT_EXTRA_SOUNDS \
    --disable chan_dahdi \
    --disable chan_mgcp \
    --disable chan_mobile \
    --disable chan_ooh323 \
    --disable chan_skinny \
    --disable app_alarmreceiver \
    --disable app_amd \
    --disable app_dahdiras \
    --disable app_festival \
    --disable app_flash \
    --disable app_meetme \
    --disable app_minivm \
    --disable app_mysql \
    --disable app_url \
    --disable app_voicemail_imap \
    --disable app_voicemail_odbc \
    --disable cdr_adaptive_odbc \
    --disable cdr_beanstalkd \
    --disable cdr_custom \
    --disable cdr_manager \
    --disable cdr_mysql \
    --disable cdr_odbc \
    --disable cdr_pgsql \
    --disable cdr_radius \
    --disable cdr_sqlite3_custom \
    --disable cdr_syslog \
    --disable cdr_tds \
    --disable codec_dahdi \
    --disable func_odbc \
    --disable res_ael_share \
    --disable res_ari \
    --disable res_calendar \
    --disable res_config_ldap \
    --disable res_config_mysql \
    --disable res_config_odbc \
    --disable res_config_pgsql \
    --disable res_hep \
    --disable res_odbc \
    --disable res_odbc_transaction \
    --disable res_parking \
    --disable res_phoneprov \
    --disable res_pjsip_transport_websocket \
    --disable res_snmp \
    --disable res_stir_shaken \
    --disable res_stun_monitor \
    --disable res_timing_dahdi\
    --enable res_pjsip \
    --enable res_pjsip_pubsub \
    --enable res_pjsip_session \
    --enable res_sorcery_config \
    --enable res_sorcery_memory \
    --enable res_sorcery_astdb \
    --enable res_statsd
