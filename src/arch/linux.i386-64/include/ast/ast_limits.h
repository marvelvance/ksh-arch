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
/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libast/features/limits.c by iffe version 2013-11-14 : : */
#ifndef _def_limits_ast
#define _def_limits_ast	1
#define _sys_types	1	/* #include <sys/types.h> ok */


#ifndef ARG_MAX
#ifndef NCARGS
#define NCARGS 131072
#endif
#define ARG_MAX NCARGS
#endif
#ifndef CHAR_BIT
#define CHAR_BIT 8
#endif
#ifndef CHAR_MAX
#define CHAR_MAX 127
#endif
#ifndef CHAR_MIN
#define CHAR_MIN -128
#endif
#ifndef CHILD_MAX
#define CHILD_MAX 30944
#endif
#ifndef FCHR_MAX
#define FCHR_MAX 2147483647
#endif
#ifndef INT_MIN
#define INT_MIN -2147483648
#endif
#ifndef LLONG_MAX
#define LLONG_MAX 9223372036854775807
#endif
#ifndef LLONG_MIN
#define LLONG_MIN -9223372036854775808
#endif
#ifndef LONG_MAX
#define LONG_MAX 9223372036854775807
#endif
#ifndef LONG_MIN
#define LONG_MIN -9223372036854775808
#endif
#ifndef MB_LEN_MAX
#define MB_LEN_MAX 16
#endif
#ifndef NSS_BUFLEN_GROUP
#define NSS_BUFLEN_GROUP 1024
#endif
#ifndef NSS_BUFLEN_PASSWD
#define NSS_BUFLEN_PASSWD 1024
#endif
#ifndef OPEN_MAX
#define OPEN_MAX 1024
#endif
#ifndef PID_MAX
#define PID_MAX 32768
#endif
#ifndef PTRDIFF_MAX
#define PTRDIFF_MAX 9223372036854775807
#endif
#ifndef PTRDIFF_MIN
#define PTRDIFF_MIN -9223372036854775808
#endif
#ifndef SCHAR_MAX
#define SCHAR_MAX 127
#endif
#ifndef SCHAR_MIN
#define SCHAR_MIN -128
#endif
#ifndef SHRT_MIN
#define SHRT_MIN -32768
#endif
#ifndef SIG_ATOMIC_MAX
#define SIG_ATOMIC_MAX 2147483647
#endif
#ifndef SIG_ATOMIC_MIN
#define SIG_ATOMIC_MIN -2147483648
#endif
#ifndef SIZE_MAX
#ifndef UINT_MAX
#define UINT_MAX 4294967295
#endif
#define SIZE_MAX UINT_MAX
#endif
#ifndef SSIZE_MAX
#ifndef INT_MAX
#define INT_MAX 2147483647
#endif
#define SSIZE_MAX INT_MAX
#endif
#ifndef STD_BLK
#define STD_BLK 1024
#endif
#ifndef SYSPID_MAX
#define SYSPID_MAX 2
#endif
#ifndef TMP_MAX
#define TMP_MAX 238328
#endif
#ifndef UCHAR_MAX
#define UCHAR_MAX 255
#endif
#ifndef UID_MAX
#define UID_MAX 60002
#endif
#ifndef ULLONG_MAX
#define ULLONG_MAX 18446744073709551615
#endif
#ifndef ULONG_MAX
#define ULONG_MAX 18446744073709551615
#endif
#ifndef USHRT_MAX
#define USHRT_MAX 65535
#endif
#ifndef WCHAR_MAX
#define WCHAR_MAX 2147483647
#endif
#ifndef WCHAR_MIN
#define WCHAR_MIN -2147483648
#endif
#ifndef WINT_MAX
#define WINT_MAX 4294967295
#endif
#ifndef WINT_MIN
#define WINT_MIN 0
#endif

#ifndef _POSIX_NAME_MAX
#define _POSIX_NAME_MAX		14
#endif
#ifndef _POSIX_PATH_MAX
#define _POSIX_PATH_MAX		256
#endif

#endif
