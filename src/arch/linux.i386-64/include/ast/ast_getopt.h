
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
 * legacy standard getopt interface
 */


#if !defined(__PROTO__)
#include <prototyped.h>
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif
#ifdef	_AST_STD_I
#undef	_AST_GETOPT_H
#define _AST_GETOPT_H		-1
#endif
#ifndef _AST_GETOPT_H
#define _AST_GETOPT_H		1

extern __MANGLE__ int	opterr;
extern __MANGLE__ int	optind;
extern __MANGLE__ int	optopt;
extern __MANGLE__ char*	optarg;

extern __MANGLE__ int	getopt __PROTO__((int, char* const*, const char*));
extern __MANGLE__ int	getsubopt __PROTO__((char**, char* const*, char**));

#endif
