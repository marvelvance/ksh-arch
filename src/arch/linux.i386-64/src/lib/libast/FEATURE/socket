/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libast/features/socket by iffe version 2013-11-14 : : */
#ifndef _AST_SOCKET_H
#define _AST_SOCKET_H	1
#define _sys_types	1	/* #include <sys/types.h> ok */
#define _nxt_sys_socket "../include/sys/socket.h"	/* include path for the native <sys/socket.h> */
#define _nxt_sys_socket_str "../include/sys/socket.h"	/* include string for the native <sys/socket.h> */

/* the socket part of ast_intercept.h */

#if _sys_socket && defined(_nxt_sys_socket)

#include _nxt_sys_socket	/* the real <sys/socket.h> */

#if _AST_INTERCEPT_IMPLEMENT < 2

#undef	accept
#define accept		ast_accept

#undef	accept4
#define accept4		ast_accept4

#undef	connect
#define connect		ast_connect

#undef	socket
#define socket		ast_socket

#undef	socketpair
#define socketpair	ast_socketpair

#endif

#if _AST_INTERCEPT_IMPLEMENT > 0

#if _BLD_ast && defined(__EXPORT__)
#define extern		__EXPORT__
#endif

extern int		ast_accept(int, struct sockaddr*, socklen_t*);
extern int		ast_accept4(int, struct sockaddr*, socklen_t*, int);
extern int		ast_connect(int, struct sockaddr*, socklen_t);
extern int		ast_socket(int, int, int);
extern int		ast_socketpair(int, int, int, int[2]);

#undef extern

#endif

#endif

#endif
