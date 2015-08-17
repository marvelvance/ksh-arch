
/* : : generated by proto : : */
/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1985-2013 AT&T Intellectual Property          *
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
 * ksh builtin command api
 */

#ifndef _SHCMD_H
#if !defined(__PROTO__)
#include <prototyped.h>
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif

#define _SHCMD_H	1

#ifndef AST_PLUGIN_VERSION
#define AST_PLUGIN_VERSION(v)	(v)
#endif
#define SH_PLUGIN_VERSION	AST_PLUGIN_VERSION(20111111L)

#if __STDC__
#define SHLIB(m)	unsigned long	plugin_version(void) { return SH_PLUGIN_VERSION; }
#else
#define SHLIB(m)	unsigned long	plugin_version() { return SH_PLUGIN_VERSION; }
#endif

#ifndef SH_VERSION
#   define Shell_t	void
#endif
#ifndef NV_DEFAULT
#   define Namval_t	void
#endif

#undef Shbltin_t
struct Shbltin_s;
typedef struct Shbltin_s Shbltin_t;

#ifdef _SHTABLE_H /* pre-ksh93u+ -- obsolete */
typedef int (*Shbltin_f) __PROTO__((int, char**, __V_*));
#else
typedef int (*Shbltin_f) __PROTO__((int, char**, Shbltin_t*));
#endif /* _SHTABLE_H */

struct Shbltin_s
{
	Shell_t*	shp;
	__V_*		ptr;
	int		version;
	int		(*shrun) __PROTO__((int, char**));
	int		(*shtrap) __PROTO__((const char*, int));
	void		(*shexit) __PROTO__((int));
	Namval_t*	(*shbltin) __PROTO__((const char*, Shbltin_f, __V_*));
	unsigned char	notify;
	unsigned char	sigset;
	unsigned char	nosfio;
	Namval_t*	bnode;
	Namval_t*	vnode;
	char*		data;
	int		flags;
	char*		(*shgetenv) __PROTO__((const char*));
	char*		(*shsetenv) __PROTO__((const char*));
	int		invariant;
	int		pwdfd;
};

#if defined(SH_VERSION) ||  defined(_SH_PRIVATE)
#   undef Shell_t
#   undef Namval_t
#else 
#   define sh_context(c)	((Shbltin_t*)(c))
#   define sh_run(c, ac, av)	((c)?(*sh_context(c)->shrun)(ac,av):-1)
#   define sh_system(c,str)	((c)?(*sh_context(c)->shtrap)(str,0):system(str))
#   define sh_exit(c,n)		((c)?(*sh_context(c)->shexit)(n):exit(n))
#   define sh_checksig(c)	((c) && sh_context(c)->sigset)
#   define sh_builtin(c,n,f,p)	((c)?(*sh_context(c)->shbltin)(n,(Shbltin_f)(f),sh_context(p)):0)
#   if defined(SFIO_VERSION) || defined(_AST_H)
#	define LIB_INIT(c)
#   else
#	define LIB_INIT(c)	((c) && (sh_context(c)->nosfio = 1))
#   endif
#   ifndef _CMD_H
#     ifndef ERROR_NOTIFY
#       define ERROR_NOTIFY	1
#     endif
#     define cmdinit(ac,av,c,cat,flg)		do { if((ac)<=0) return(0); \
	(sh_context(c)->notify = ((flg)&ERROR_NOTIFY)?1:0);} while(0)
#   endif
#endif

#if _BLD_ast && defined(__EXPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__		__EXPORT__
#endif

extern __MANGLE__ int		astintercept __PROTO__((Shbltin_t*, int));

#undef __MANGLE__
#define __MANGLE__ __LINKAGE__

#endif
