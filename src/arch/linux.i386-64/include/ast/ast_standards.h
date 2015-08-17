/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1985-2015 AT&T Intellectual Property          *
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
/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libast/features/standards by iffe version 2013-11-14 : : */
#ifndef _def_standards_ast
#define _def_standards_ast	1
#define _sys_types	1	/* #include <sys/types.h> ok */
/* _GNU_SOURCE works */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif

#define _LIB_m	1	/* -lm is a library */
/* _ISOC99_SOURCE plays nice */
#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE	1
#endif


/*
* this is a nasty game we all play to honor standards symbol visibility
* it would help if all implementations had
*	_KITCHEN_SINK_SOURCE
* that enabled all symbols from the latest implemented standards
* that's probably the most useful but least portable request
*/

#if __MACH__
#undef  _POSIX_SOURCE
#undef  _POSIX_C_SOURCE
#undef  _XOPEN_SOURCE
#endif


#endif
