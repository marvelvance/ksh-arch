/***********************************************************************
*                                                                      *
*               This software is part of the ast package               *
*          Copyright (c) 1990-2015 AT&T Intellectual Property          *
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
*                                                                      *
***********************************************************************/
/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libcs/features/lib by iffe version 2013-11-14 : : */
#ifndef _def_lib_cs
#define _def_lib_cs	1
#define _sys_types	1	/* #include <sys/types.h> ok */
#define _LIB_ast	1	/* -last is a library */
#define _LIB_dl	1	/* -ldl is a library */
#define _LIB_nsl	1	/* -lnsl is a library */
#define _hdr_netdb	1	/* #include <netdb.h> ok */
#define _hdr_stropts	1	/* #include <stropts.h> ok */
#define _hdr_netinet_in	1	/* #include <netinet/in.h> ok */
#define _hdr_netinet_tcp	1	/* #include <netinet/tcp.h> ok */
#define _lib_fattach	1	/* fattach() in default lib(s) */
#define _lib_getdtablesize	1	/* getdtablesize() in default lib(s) */
#define _lib_gethostname	1	/* gethostname() in default lib(s) */
#define _lib_getrlimit	1	/* getrlimit() in default lib(s) */
#define _lib_sigblock	1	/* sigblock() in default lib(s) */
#define _lib_uname	1	/* uname() in default lib(s) */
#define _lib_recvmsg	1	/* recvmsg() in default lib(s) */
#define _lib_sendmsg	1	/* sendmsg() in default lib(s) */
#define _sys_socket	1	/* #include <sys/socket.h> ok */
#define _lib_ntohs	1	/* ntohs() in default lib(s) */
#define _lib_ntohl	1	/* ntohl() in default lib(s) */
#define _lib_htons	1	/* htons() in default lib(s) */
#define _lib_htonl	1	/* htonl() in default lib(s) */
#define _sys_statvfs	1	/* #include <sys/statvfs.h> ok */
#define _sys_uio	1	/* #include <sys/uio.h> ok */
#define _mem_msg_control_msghdr	1	/* msg_control is a member of struct msghdr */
#define _mem_msg_flags_msghdr	1	/* msg_flags is a member of struct msghdr */
#define _sys_utsname	1	/* #include <sys/utsname.h> ok */
#define _hdr_poll	1	/* #include <poll.h> ok */
#define _sys_file	1	/* #include <sys/file.h> ok */
#define _sys_resource	1	/* #include <sys/resource.h> ok */
#define _sys_select	1	/* #include <sys/select.h> ok */
#define _sys_un	1	/* #include <sys/un.h> ok */
#define CS_REMOTE_SHELL	"/usr/bin/ssh"	/* remote shell path */
#define _tst_rsh	1	/* run{\ passed */
typedef int Sock_size_t;
#if _sys_inet_tcp_user
#define CS_LIB_V10	1
#else
#if _sys_socket && _hdr_netdb
#define CS_LIB_SOCKET	1
#if _sys_un
#define CS_LIB_SOCKET_UN	1
#if _mem_msg_accrights_msghdr && ! _mem_msg_flags_msghdr
#undef _mem_msg_control_msghdr
#endif
#if _lib_recvmsg && _lib_sendmsg && ( _mem_msg_accrights_msghdr || _mem_msg_control_msghdr )
#define CS_LIB_SOCKET_RIGHTS	1
#endif
#endif
#endif
#if _hdr_stropts && _lib_fattach && _stream_pipe
#define CS_LIB_STREAM	1
#endif
#endif
#if !_sys_statvfs
#define _mem_f_fstr_statvfs	1
#define _mem_f_fsid_statvfs	1
#endif

#define _mem_f_fsid_statvfs	1	/* compile{\ passed */
#endif
