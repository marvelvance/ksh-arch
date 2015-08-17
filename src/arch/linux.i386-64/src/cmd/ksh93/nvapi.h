/* : : generated from /home/marvel/Downloads/ksh/src/src/cmd/ksh93/features/nvapi by iffe version 2013-11-14 : : */
#ifndef _NV_API_H
#define _NV_API_H	1
#define _sys_types	1	/* #include <sys/types.h> ok */
#define _LIB_m	1	/* -lm is a library */
#define _LIB_util	1	/* -lutil is a library */
#define _LIB_cmd	1	/* -lcmd is a library */
#define _LIB_ast	1	/* ../../../lib/libast.a is a library */
#define _LIB_dl	1	/* -ldl is a library */
#define _LIB_dll	1	/* -ldll is a library */
#ifndef _API_nv
#define _API_nv	_API_shell
#endif
#define NVAPI(rel)	( _BLD_nv || !_API_nv || _API_nv >= rel )

#ifndef _NV_API_IMPLEMENT
#define _NV_API_IMPLEMENT	1


#if !defined(_API_nv) && defined(_API_DEFAULT)
#define _API_nv	_API_DEFAULT
#endif

#if NVAPI(20120720)
#undef	nv_lastdict
#define nv_lastdict	nv_lastdict_20120720
#endif

#if NVAPI(20120720)
#undef	nv_putsub
#define nv_putsub	nv_putsub_20120720
#endif

#define _API_nv_MAP	"nv_lastdict_20120720 nv_putsub_20120720"

#endif

#endif
