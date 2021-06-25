/*
 * Asterisk -- An open source telephony toolkit.
 *
 * Copyright (C) 2013, Digium, Inc.
 *
 * See http://www.asterisk.org for more information about
 * the Asterisk project. Please do not directly contact
 * any of the maintainers of this project for assistance;
 * the project provides a web site, mailing lists and IRC
 * channels for your use.
 *
 * This program is free software, distributed under the terms of
 * the GNU General Public License Version 2. See the LICENSE file
 * at the top of the source tree.
 */

/*!
 * \file
 * \brief PJSIP Channel Driver shared data structures
 */

#ifndef _CHAN_PJSIP_HEADER
#define _CHAN_PJSIP_HEADER

struct ast_sip_session_media;

/*!
 * \brief Transport information stored in transport_info datastore
 */
struct transport_info_data {
	/*! \brief The address that sent the request */
	pj_sockaddr remote_addr;
	/*! \brief Our address that received the request */
	pj_sockaddr local_addr;
};

/*!
 * \brief Positions of various media
 */
enum sip_session_media_position {
	/*! \brief First is audio */
	SIP_MEDIA_AUDIO = 0,
	/*! \brief Second is video */
	SIP_MEDIA_VIDEO,
	/*! \brief Last is the size for media details */
	SIP_MEDIA_SIZE,
};

/*!
 * \brief The PJSIP channel driver pvt, stored in the \ref ast_sip_channel_pvt
 * data structure
 */
struct chan_pjsip_pvt {
	/*! \brief The available media sessions */
	struct ast_sip_session_media *media[SIP_MEDIA_SIZE];
};

#endif /* _CHAN_PJSIP_HEADER */
