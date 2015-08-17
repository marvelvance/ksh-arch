/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libcs/features/cs.c by iffe version 2013-11-14 : : */
#ifndef _def_cs_cs
#define _def_cs_cs	1
#define _sys_types	1	/* #include <sys/types.h> ok */
#define _LIB_ast	1	/* -last is a library */
#define _LIB_dl	1	/* -ldl is a library */
#define _LIB_nsl	1	/* -lnsl is a library */
#define CS_REMOTE_SHELL	"/usr/bin/ssh"

#define CS_TCP	1
#define CS_UDP	1
#define CS_FDP	1

#define revents	status
#include <poll.h>
#undef	revents

#define CS_POLL_CLOSE	POLLHUP
#define CS_POLL_CONTROL	POLLPRI
#define CS_POLL_ERROR	POLLERR
#define CS_POLL_INVALID	POLLNVAL
#define CS_POLL_READ	POLLIN
#define CS_POLL_WRITE	POLLOUT

#define CS_POLL_PSEUDO	(CS_POLL_AUTH|CS_POLL_CONNECT|CS_POLL_USER|CS_POLL_BEFORE)
#define CS_POLL_AUTH	(1<<10)
#define CS_POLL_CONNECT	(1<<11)
#define CS_POLL_USER	(1<<12)
#define CS_POLL_BEFORE	(1<<13)

typedef struct pollfd Cspoll_t;
#endif
