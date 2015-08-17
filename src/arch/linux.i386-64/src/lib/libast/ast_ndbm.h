/* : : generated from /home/marvel/Downloads/ksh/src/src/lib/libast/features/ndbm by iffe version 2013-11-14 : : */
#ifndef _def_ndbm_ast
#define _def_ndbm_ast	1
#define _sys_types	1	/* #include <sys/types.h> ok */
#define _LIB_db	1	/* -ldb is a library */
/* sleepycat ndbm compatibility */
#ifndef DB_DBM_HSEARCH
#define DB_DBM_HSEARCH	1
#include <db.h>
#endif
#define _use_ndbm	1

#endif
