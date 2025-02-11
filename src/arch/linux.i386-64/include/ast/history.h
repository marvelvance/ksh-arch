
/* : : generated by proto : : */
/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1982-2012 AT&T Intellectual Property          *
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
*                    David Korn <dgkorn@gmail.com>                     *
*                                                                      *
***********************************************************************/
                  
#ifndef HIST_VERSION
#if !defined(__PROTO__)
#include <prototyped.h>
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif

/*
 *	Interface for history mechanism
 *	written by David Korn
 *
 */

#include	<ast.h>

#define HIST_CHAR	'!'
#define HIST_VERSION	1		/* history file format version no. */

typedef struct 
{
	Sfdisc_t	histdisc;	/* discipline for history */
	Sfio_t		*histfp;	/* history file stream pointer */
	char		*histname;	/* name of history file */
	int32_t		histind;	/* current command number index */
	int		histsize;	/* number of accessible history lines */
#ifdef _HIST_PRIVATE
	_HIST_PRIVATE
#endif /* _HIST_PRIVATE */
} History_t;

typedef struct
{
	int hist_command;
	int hist_line;
	int hist_char;
} Histloc_t;

/* the following are readonly */
extern __MANGLE__ const char	hist_fname[];

extern __MANGLE__ int _Hist;
#define	hist_min(hp)	((_Hist=((int)((hp)->histind-(hp)->histsize)))>=0?_Hist:0)
#define	hist_max(hp)	((int)((hp)->histind))
/* these are the history interface routines */
extern __MANGLE__ int		sh_histinit __PROTO__((__V_ *));
extern __MANGLE__ void 		hist_cancel __PROTO__((History_t*));
extern __MANGLE__ void 		hist_close __PROTO__((History_t*));
extern __MANGLE__ int		hist_copy __PROTO__((char*, int, int, int));
extern __MANGLE__ void 		hist_eof __PROTO__((History_t*));
extern __MANGLE__ Histloc_t	hist_find __PROTO__((History_t*,char*,int, int, int));
extern __MANGLE__ void 		hist_flush __PROTO__((History_t*));
extern __MANGLE__ void 		hist_list __PROTO__((History_t*,Sfio_t*, off_t, int, char*));
extern __MANGLE__ int		hist_match __PROTO__((History_t*,off_t, char*, int*));
extern __MANGLE__ off_t		hist_tell __PROTO__((History_t*,int));
extern __MANGLE__ off_t		hist_seek __PROTO__((History_t*,int));
extern __MANGLE__ char 		*hist_word __PROTO__((char*, int, int));
extern __MANGLE__ Histloc_t	hist_locate __PROTO__((History_t*,int, int, int));

#endif /* HIST_VERSION */
