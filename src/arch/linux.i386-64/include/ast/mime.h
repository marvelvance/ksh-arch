
/* : : generated by proto : : */
/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1985-2011 AT&T Intellectual Property          *
*                      and is licensed under the                       *
*                 Eclipse Public License, Version 1.0                  *
*                    by AT&T Intellectual Property                     *
*                                                                      *
*                A copy of the License is available at                 *
*          http://www.eclipse.org/org/documents/epl-v10.html           *
*         (with md5 checksum b35adb5213ca9657e911e9befb180842)         *
*                                                                      *
*              Information and Software Systems Research               *
*                            AT&T Research                             *
*                           Florham Park NJ                            *
*                                                                      *
*               Glenn Fowler <glenn.s.fowler@gmail.com>                *
*                    David Korn <dgkorn@gmail.com>                     *
*                     Phong Vo <phongvo@gmail.com>                     *
*                                                                      *
***********************************************************************/
                  

/*
 * mime/mailcap interface
 */

#ifndef _MIMETYPE_H
#if !defined(__PROTO__)
#include <prototyped.h>
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif

#define _MIMETYPE_H	1

#include <sfio.h>
#include <ls.h>

#define MIME_VERSION	19970717L

#ifndef MIME_FILES
#define MIME_FILES	"~/.mailcap:/usr/local/etc/mailcap:/usr/etc/mailcap:/etc/mailcap:/etc/mail/mailcap:/usr/public/lib/mailcap"
#endif

#define MIME_FILES_ENV	"MAILCAP"

#define MIME_LIST	(1<<0)		/* mimeload arg is : list	*/
#define MIME_NOMAGIC	(1<<1)		/* no magic for mimetype()	*/
#define MIME_PIPE	(1<<2)		/* mimeview() io is piped	*/
#define MIME_REPLACE	(1<<3)		/* replace existing definition	*/

#define MIME_USER	(1L<<16)	/* first user flag bit		*/

struct Mime_s;
typedef struct Mime_s Mime_t;

struct Mimedisc_s;
typedef struct Mimedisc_s Mimedisc_t;

typedef int (*Mimevalue_f) __PROTO__((Mime_t*, __V_*, char*, size_t, Mimedisc_t*));

struct Mimedisc_s
{
	unsigned long	version;	/* interface version		*/
	unsigned long	flags;		/* MIME_* flags			*/
	Error_f		errorf;		/* error function		*/
	Mimevalue_f	valuef;		/* value extraction function	*/
};

struct Mime_s
{
	const char*	id;		/* library id string		*/

#ifdef _MIME_PRIVATE_
	_MIME_PRIVATE_
#endif

};

#if _BLD_ast && defined(__EXPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__		__EXPORT__
#endif

extern __MANGLE__ Mime_t*	mimeopen __PROTO__((Mimedisc_t*));
extern __MANGLE__ int	mimeload __PROTO__((Mime_t*, const char*, unsigned long));
extern __MANGLE__ int	mimelist __PROTO__((Mime_t*, Sfio_t*, const char*));
extern __MANGLE__ int	mimeclose __PROTO__((Mime_t*));
extern __MANGLE__ int	mimeset __PROTO__((Mime_t*, char*, unsigned long));
extern __MANGLE__ char*	mimetype __PROTO__((Mime_t*, Sfio_t*, const char*, struct stat*));
extern __MANGLE__ char*	mimeview __PROTO__((Mime_t*, const char*, const char*, const char*, const char*));
extern __MANGLE__ int	mimehead __PROTO__((Mime_t*, __V_*, size_t, size_t, char*));
extern __MANGLE__ int	mimecmp __PROTO__((const char*, const char*, char**));

#undef __MANGLE__
#define __MANGLE__ __LINKAGE__

#endif
