
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
 * David Korn
 * AT&T Research
 *
 * Interface definitions for a stack-like storage library
 *
 */

#ifndef _STK_H
#if !defined(__PROTO__)
#include <prototyped.h>
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif

#define _STK_H

#include <sfio.h>

#define _Stk_data	_Stak_data

#define stkstd		(&_Stk_data)

#define	Stk_t		Sfio_t

#define STK_SMALL	1		/* small stkopen stack		*/
#define STK_NULL	2		/* return NULL on overflow	*/

#define	stkptr(sp,n)	((char*)((sp)->_data)+(n))
#define stktop(sp)	((char*)(sp)->_next)
#define	stktell(sp)	((sp)->_next-(sp)->_data)
#define stkseek(sp,n)	((n)==0?(char*)((sp)->_next=(sp)->_data):_stkseek(sp,n))

#if _BLD_ast && defined(__EXPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__ __EXPORT__
#endif
#if !_BLD_ast && defined(__IMPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__ __IMPORT__
#endif

extern __MANGLE__ Sfio_t		_Stk_data;

#undef __MANGLE__
#define __MANGLE__ __LINKAGE__

#if _BLD_ast && defined(__EXPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__		__EXPORT__
#endif

extern __MANGLE__ Stk_t*		stkopen __PROTO__((int));
extern __MANGLE__ Stk_t*		stkinstall __PROTO__((Stk_t*, char*(*)(int)));
extern __MANGLE__ int		stkclose __PROTO__((Stk_t*));
extern __MANGLE__ int		stklink __PROTO__((Stk_t*));
extern __MANGLE__ char*		stkalloc __PROTO__((Stk_t*, size_t));
extern __MANGLE__ char*		stkcopy __PROTO__((Stk_t*, const char*));
extern __MANGLE__ char*		stkset __PROTO__((Stk_t*, char*, size_t));
extern __MANGLE__ char*		_stkseek __PROTO__((Stk_t*, ssize_t));
extern __MANGLE__ char*		stkfreeze __PROTO__((Stk_t*, size_t));
extern __MANGLE__ int		stkon __PROTO__((Stk_t*, char*));

#undef __MANGLE__
#define __MANGLE__ __LINKAGE__

#endif
