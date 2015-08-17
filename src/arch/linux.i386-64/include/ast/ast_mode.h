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
/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libast/features/mode.c by iffe version 2013-11-14 : : */
#ifndef _def_mode_ast
#define _def_mode_ast	1
#define _sys_types	1	/* #include <sys/types.h> ok */
#define S_ITYPE(m)	((m)&S_IFMT)

#define S_IPERM		(S_ISUID|S_ISGID|S_ISVTX|S_IRWXU|S_IRWXG|S_IRWXO)

#define _S_IDPERM	1
#define _S_IDTYPE	1

#define BUFFERSIZE	8192

#endif
