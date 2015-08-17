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

/* : : generated by proto : : */
/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libast/features/fcntl.c by iffe version 2013-11-14 : : */
#ifndef _def_fcntl_ast
#if !defined(__PROTO__)
#  if defined(__STDC__) || defined(__cplusplus) || defined(_proto) || defined(c_plusplus)
#    if defined(__cplusplus)
#      define __LINKAGE__	"C"
#    else
#      define __LINKAGE__
#    endif
#    define __STDARG__
#    define __PROTO__(x)	x
#    define __OTORP__(x)
#    define __PARAM__(n,o)	n
#    if !defined(__STDC__) && !defined(__cplusplus)
#      if !defined(c_plusplus)
#      	define const
#      endif
#      define signed
#      define void		int
#      define volatile
#      define __V_		char
#    else
#      define __V_		void
#    endif
#  else
#    define __PROTO__(x)	()
#    define __OTORP__(x)	x
#    define __PARAM__(n,o)	o
#    define __LINKAGE__
#    define __V_		char
#    define const
#    define signed
#    define void		int
#    define volatile
#  endif
#  define __MANGLE__	__LINKAGE__
#  if defined(__cplusplus) || defined(c_plusplus)
#    define __VARARG__	...
#  else
#    define __VARARG__
#  endif
#  if defined(__STDARG__)
#    define __VA_START__(p,a)	va_start(p,a)
#  else
#    define __VA_START__(p,a)	va_start(p)
#  endif
#  if !defined(__INLINE__)
#    if defined(__cplusplus)
#      define __INLINE__	extern __MANGLE__ inline
#    else
#      if defined(_WIN32) && !defined(__GNUC__)
#      	define __INLINE__	__inline
#      endif
#    endif
#  endif
#endif
#if !defined(__LINKAGE__)
#define __LINKAGE__		/* 2004-08-11 transition */
#endif

#define _def_fcntl_ast	1
#define _sys_types	1	/* #include <sys/types.h> ok */
                  

#if _typ_off64_t
#undef	off_t
#ifdef __STDC__
#define	off_t		off_t
#endif
#endif

#include <ast_fs.h>

#if _typ_off64_t
#undef	off_t
#ifdef __STDC__
#define	off_t		off_t
#endif
#endif

#include <fcntl.h>
#include <sys/mman.h>

#ifndef F_DUPFD_CLOEXEC
#define F_DUPFD_CLOEXEC	(1030)	/* just in case _*_SOURCE circumvented */
#endif

#define O_INTERCEPT		020000000000	/* ast extension */
#ifndef O_SEARCH
#define O_SEARCH		000010000000	/* O_PATH */
#endif
#ifndef O_DIRECTORY
#define O_DIRECTORY		000000200000	/* just in case _*_SOURCE circumvented */
#endif
#ifndef O_CLOEXEC
#define O_CLOEXEC		000002000000	/* just in case _*_SOURCE circumvented */
#endif

#define _ast_O_LOCAL		020000000000	/* ast extension up to 020000000000 */

#define O_BINARY		0		/* not implemented */
#ifndef O_DIRECT
#define O_DIRECT		000000040000	/* just in case _*_SOURCE circumvented */
#endif
#ifndef O_NOFOLLOW
#define O_NOFOLLOW		000000400000	/* just in case _*_SOURCE circumvented */
#endif
#ifndef O_NOATIME
#define O_NOATIME		000001000000	/* just in case _*_SOURCE circumvented */
#endif
#define O_TEMPORARY		0		/* not implemented */
#define O_TEXT			0		/* not implemented */

#define F_dupfd_cloexec		F_DUPFD_CLOEXEC /* OBSOLETE */
#define O_cloexec		O_CLOEXEC /* OBSOLETE*/

#include <ast_fs.h>
#if _typ_off64_t
#undef	off_t
#define	off_t		off64_t
#endif
#if _lib_fstat64
#define fstat		fstat64
#endif
#if _lib_fstatat64
#define fstatat		fstatat64
#endif
#if _lib_lstat64
#define lstat		lstat64
#endif
#if _lib_stat64
#define stat		stat64
#endif
#if _lib_creat64
#define creat		creat64
#endif
#if _lib_mmap64
#define mmap		mmap64
#endif
#if _lib_open64
#undef	open
#define open		open64
#endif

#if _BLD_ast && defined(__EXPORT__)
#undef __MANGLE__
#define __MANGLE__ __LINKAGE__	__EXPORT__
#endif
#if !_lib_faccessat
extern __MANGLE__ int	faccessat __PROTO__((int, const char*, mode_t, int));
#endif
#if !_lib_fchmodat
extern __MANGLE__ int	fchmodat __PROTO__((int, const char*, mode_t, int));
#endif
#if !_lib_fchownat
extern __MANGLE__ int	fchownat __PROTO__((int, const char*, uid_t, gid_t, int));
#endif
#if !_lib_fstatat
struct stat;
extern __MANGLE__ int	fstatat __PROTO__((int, const char*, struct stat*, int));
#endif
#if !_lib_linkat
extern __MANGLE__ int	linkat __PROTO__((int, const char*, int, const char*, int));
#endif
#if !_lib_mkdirat
extern __MANGLE__ int	mkdirat __PROTO__((int, const char*, mode_t));
#endif
#if !_lib_mkfifoat
extern __MANGLE__ int	mkfifoat __PROTO__((int, const char*, mode_t));
#endif
#if !_lib_mknodat
extern __MANGLE__ int	mknodat __PROTO__((int, const char*, mode_t, dev_t));
#endif
#if !_lib_openat
extern __MANGLE__ int	openat __PROTO__((int, const char*, int, ...));
#endif
#if !_lib_readlinkat
extern __MANGLE__ ssize_t	readlinkat __PROTO__((int, const char*, char*, size_t));
#endif
#if !_lib_renameat
extern __MANGLE__ int	renameat __PROTO__((int, const char*, int, const char*));
#endif
#if !_lib_symlinkat
extern __MANGLE__ int	symlinkat __PROTO__((const char*, int, const char*));
#endif
#if !_lib_unlinkat
extern __MANGLE__ int	unlinkat __PROTO__((int, const char*, int));
#endif

#undef __MANGLE__
#define __MANGLE__ __LINKAGE__
#endif
