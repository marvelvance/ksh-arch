:
### this script contains archaic constructs that work with all sh variants ###
# Glenn Fowler
# AT&T Research
#
# @(#)C probe (AT&T Research) 2013-05-21
#
# probe [ -d ] c-compiler-path [ attributes ]
#
# common C probe preamble for the tool specific probes
#
# NOTE: some cc -E's do syntax analysis!

#
# probe_* are first eval'd and then attempted from left to right
#

probe_binding="-dy -dn -Bdynamic -Bstatic '-Wl,-ashared -Wl,+s' -Wl,-aarchive -call_shared -non_shared -dynamic -static -bshared -bstatic '' -static"
probe_env="CC_OPTIONS CCOPTS LD_OPTIONS LDOPTS LIBPATH LPATH"
probe_include="stdio.h iostream.h complex.h ctype.h plot.h stdarg.h varargs.h ranlib.h hash.h sys/types.h stab.h cmath cstdio iostream string"
probe_longlong="long 'long long'"
probe_longlong_t="__int64_t _int64_t __int64 _int64 int64"
probe_l="l yyreject m sin mopt sin"
probe_lxx="C exit ++ exit g++ exit"
probe_ppprefix="a n"
probe_size="size"
probe_src="cxx C cc c"
probe_sa=".sa"
probe_sd=".dll .lib .dll .x"
probe_sdb=".pdb"
probe_so=".dylib .so .sl"
probe_symprefix="_"
probe_verbose="'-v -v' '-# -#' '-d -d' -dryrun '-V -V'"
probe_version="--version -V -version -v"

#
# the following are set by the preamble for the tool specific probe
#

cc=cc
debug=
dir=.
dll=.dll
dynamic=
exe=exe
executable="test -x"
hosted=
ifs=${IFS-'
	 '}
obj=o
ppenv=
ppopt=
predef=
prepred=
sa=
sd=
sdb=
so=
sov=
static=
stdlib=
stdpp=
suffix_command=
if	test "" != "$TMPDIR" -a -d "$TMPDIR"
then	tmpdir=$TMPDIR
else	tmpdir=/tmp
fi
tmpdir=$tmpdir/probe$$
undef="define defined elif else endif error if ifdef ifndef include line pragma undef __STDC__ __STDPP__ __ARGC__ __BASE__ __BASE_FILE__ __DATE__ __FILE__ __FUNCTION__ __INCLUDE_LEVEL__ __LINE__ __PATH__ __TIME__ __TIMESTAMP__ __VERSION__"
version_flags=
version_stamp=
version_string=

#
# constrain the environment
#

DISPLAY=
LC_ALL=C
export DISPLAY LC_ALL

#
# now the common probes
#

while	:
do	case $1 in
	-d)	debug=1 ;;
	-*)	set ''; break ;;
	*)	break ;;
	esac
	shift
done

cc=$1
case $cc in
[\\/]*|[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:\\*)
	;;
*)	echo "Usage: $0 [ -d ] c-compiler-path [ attributes ]" >&2
	exit 1
	;;
esac
ATTRIBUTES=
eval $2
_probe_PATH=$PATH
PATH=/usr/bin:/bin:$PATH

case $0 in
*[\\/]*)	dir=`echo $0 | sed -e 's,[\\/][\\/]*[^\\/]*\$,,'` ;;
esac

$executable . 2>/dev/null || executable='test -r'

case $SHELL in
[\\/]*|[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:\\*)
	sh=$SHELL
	;;
*)	sh=/bin/sh
	;;
esac

trap 'code=$?; cd ..; rm -rf $tmpdir; exit $code' 0 1 2 3
mkdir $tmpdir
cd $tmpdir

exec 3>&1 4>&2 </dev/null
case $debug in
"")	exec >/dev/null 2>&1
	(ulimit -c 0) >/dev/null 2>&1 && ulimit -c 0
	;;
*)	PS4='+$LINENO+ '
	set -x
	;;
esac

if	(xxx=xxx; unset xxx)
then	UNSET=1
else	UNSET=
fi
eval set x $probe_env
while	:
do	shift
	case $# in
	0)	break ;;
	esac
	eval x='$'$1
	case $x in
	'')	continue ;;
	esac
	case $1 in
	*PATH)	_probe_export="$_probe_export $1='$x'" ;;
	esac
	case $UNSET in
	'')	eval $1=
		export $1
		;;
	*)	unset $1
		;;
	esac
done

if	test -f "$dir/probe.ini"
then	. "$dir/probe.ini"
	IFS=$ifs
fi

mkdir suffix
cd suffix
for src in $probe_src
do	echo "int main(){return 0;}" > ../test.$src
	rm -f test*
	if	$cc -c ../test.$src
	then	set test.*
		if	test -f "$1"
		then	o="$*"
			mv $* ..
			for i in $o
			do	if	$cc -o test.exe ../$i
				then	obj=`echo "$i" | sed -e 's,test.,,'`
					$executable test.exe || executable="test -r"
					set test*
					rm *
					if	$cc -o test ../$i
					then	rm $*
						set test.*
						if	$executable "$1"
						then	exe=`echo "$1" | sed -e 's,test.,,'`
							suffix_command=.$exe
						fi
					fi
					break 2
				fi
			done
		fi
	fi
done
cd ..

case $src in
c)	;;
*)	echo '// (
int
main()
{
	class { public: int i; } j;
	j.i = 0;
	int k = j.i + 1;
	return k;
}' > dialect.$src
	if	$cc -c dialect.$src && $cc -o dialect.$exe dialect.$obj && $executable dialect.$exe
	then	mv dialect.$src dialect.c
		rm -f dialect.$obj dialect.$exe
		if	$cc -c dialect.c && $cc -o dialect.$exe dialect.$obj && $executable dialect.$exe
		then	src=c
		else	set x $cc
			while	:
			do	shift
				case $# in
				0)	break ;;
				esac
				case $1 in
				*=*)	continue ;;
				esac
				case `echo $1 | sed -e 's,.*/,,'` in
				*CC*|*++*|*[xX][xX]*|*[pP][lL][uU][sS]*) ;;
				*)	src=c ;;
				esac
				break
			done
		fi
	else	src=c
	fi
	;;
esac

set x x '(' 1 'int x;' 0
while	:
do	shift
	shift
	case $# in
	[01])	break ;;
	esac
	rm -f test.$obj
	echo "$1" > test.$src
	$cc -c test.$src
	r=$?
	case $r in
	0)	test -f test.$obj || r=1 ;;
	*)	r=1 ;;
	esac
	case $2:$r in
	0:0)	;;
	0:1)	echo "$cc: not a C compiler: failed to compile \`\`$1''" >&4
		exit 1
		;;
	1:0)	echo "$cc: not a C compiler: successfully compiled \`\`$1''" >&4
		exit 1
		;;
	esac
done

hosttype=`package CC="$cc" || $SHELL -c "package CC='$cc'"`
case $hosttype in
*[Uu][Ss][Aa][Gg][Ee]:*)
	hosttype=`PATH=$_probe_PATH; export PATH; package CC="$cc" || $SHELL -c "package CC='$cc'"`
	;;
esac

echo '#include <stdio.h>
int main(){printf("hello");return 0;}' > dynamic.$src
echo 'extern int sfclose() { return 0; }' > fun.$src
if	$cc -c dynamic.$src && $cc -c fun.$src
then	eval set x $probe_so
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		for i in foo junk
		do	rm -f dynamic.$exe
			if	$cc -L. -o dynamic.$exe dynamic.$obj -l$i
			then	: "there's really a -l$i"?
			else	rm -f dynamic.$exe
				cat fun.$obj > lib$i$1
				$cc -L. -o dynamic.$exe dynamic.$obj -l$i && $executable dynamic.$exe
				x=$?
				rm lib$i$1
				case $x in
				0)	so=$1
					rm -f dynamic.$exe > lib$i$1.1
					$cc -L. -o dynamic.$exe dynamic.$obj -l$i && $executable dynamic.$exe
					x=$?
					rm lib$i$1.1
					case $x in
					0)	sov=1 ;;
					esac
					break 2
					;;
				*)	break
					;;
				esac
			fi
		done
		k=
		for i in "" .1 .2 .3 .4 .5 .6 .7 .8 .9
		do	rm -f dynamic.$exe > libc$1$i
			$cc -L. -o dynamic.$exe dynamic.$obj && $executable dynamic.$exe
			x=$?
			(cd ..; rm $tmpdir/libc$1$i)
			case $x in
			0)	;;
			*)	k=X$k
				case $k in
				XXX)	break ;;
				esac
				;;
			esac
		done
		case $k in
		XXX)	so=$1
			sov=1
			break
			;;
		?*)	so=$1
			break
			;;
		esac
	done
	rm -f dynamic.$exe
	if	$cc -o dynamic.$exe dynamic.$obj 2>e && $executable dynamic.$exe
	then	e=`wc -l e`
		maybe=
		eval set x x $probe_binding
		while	:
		do	shift
			shift
			case $# in
			0)	break ;;
			esac
			rm -f dynamic.$exe
			$cc -o dynamic.$exe $1 dynamic.$obj 2>e && $executable dynamic.$exe || continue
			case $1 in
			?*)	case $maybe in
				"")	maybe=$1 ;;
				*)	maybe=-- ;;
				esac
				;;
			esac
			case `wc -l e` in
			$e)	;;
			*)	continue ;;
			esac
			d=`ls -s dynamic.$exe`
			rm -f dynamic.$exe
			$cc -o dynamic.$exe $2 dynamic.$obj 2>e && $executable dynamic.$exe || continue
			case `wc -l e` in
			$e)	;;
			*)	continue ;;
			esac
			case `ls -s dynamic.$exe` in
			$d)	;;
			*)	dynamic=$1
				static=$2
				maybe=
				break
				;;
			esac
		done
		case $maybe in
		""|--)	;;
		*)	rm -f dynamic.$exe
			if	$cc -o dynamic.$exe $maybe dynamic.$obj 2>e && $executable dynamic.$exe
			then	e=`wc -l e`
				if	$cc -o dynamic.$exe $maybe-bogus-bogus-bogus dynamic.$obj 2>e && $executable dynamic.$exe
				then	case `wc -l e` in
					$e)	;;
					*)	dynamic=$maybe ;;
					esac
				else	dynamic=$maybe
				fi
			fi
			;;
		esac
	fi
fi

eval set x $probe_version
shift
for o in "$@"
do	if	$cc $o > version.out 2>&1
	then	version_string=`sed -e '/ is /d' -e 's/;/ /g' version.out | sed -e 1q`
		case $version_string in
		''|*[Ee][Rr][Rr][Oo][Rr]*|*[Ff][Aa][Tt][Aa][Ll]*|*[Ww][Aa][Rr][Nn][Ii][Nn][Gg]*|*[Oo][Pp][Tt][Ii][Oo][Nn]*)
			;;
		*)	version_flags=$o
			version_stamp=";VERSION;$o;$version_string;PATH;$cc"
			break
			;;
		esac
	fi
done
case $version_stamp in
'')	eval set x $probe_version
	shift
	echo 'int main() { return 0; }' > version.i
	for o in "$@"
	do	if	$cc -c $o version.i > version.out 2>&1
		then	version_string=`sed -e '/ is /d' -e 's/;/ /g' version.out | sed -e 1q`
			case $version_string in
			''|*[Ee][Rr][Rr][Oo][Rr]*|*[Ff][Aa][Tt][Aa][Ll]*|*[Ww][Aa][Rr][Nn][Ii][Nn][Gg]*|*[Oo][Pp][Tt][Ii][Oo][Nn]*)
				;;
			*)	version_flags=$o
				break
				;;
			esac
		fi
	done
	;;
esac

echo 'int main(){return 0;}' > hosted.$src
$cc -o hosted.$exe hosted.$src && ./hosted.$exe && hosted=1

echo '#!'$sh'
echo "" $@' > cpp
chmod +x cpp
case `./cpp -Dprobe` in
*-Dprobe*)
	;;
*)	cp /bin/echo cpp
	chmod u+w cpp
	;;
esac
for prefix in $probe_ppprefix `echo $cc | sed -e '/cc\$/!d' -e 's,cc\$,,' -e 's,.*/,,'`
do	cp cpp ${prefix}cpp
done

echo "" > flags.$src
echo '#pragma pp:version' > libpp.$src

# this works around a `...` hang in ksh-2013-05-20 -- to be solved another day #
eval 'shell=$(echo modern)' >/dev/null 2>&1
case $shell in
modern)	if	test $(realcppC=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppenv='realcppC=${ppcmd}'
	elif	test $(cppC=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppenv='cppC=${ppcmd}'
	elif	test $(_CPPNAME=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppenv='_CPPNAME=${ppcmd}'
	elif	test $(_CPP=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppenv='_CPP=${ppcmd}'
	elif	test $($cc -Dprobe -E -%p+. flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1 && test `$cc -Dprobe -E -%p+. flags.$src | wc -l` -eq 1
	then	ppopt='-%p+${ppdir}'
	elif	test $($cc -Dprobe -E -Yp,. flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-Yp,${ppdir}'
	elif	test $($cc -Dprobe -E -Qpath $tmpdir flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-Qpath ${ppdir}'
	elif	test $($cc -Dprobe -E -tp -B./ flags.$src 2>err.out | tee cpp.out | grep -c '[-]Dprobe') -eq 1 -a ! -s err.out
	then	ppopt='-tp -B${ppdir}/'
	elif	test $($cc -Dprobe -E -B./ flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-B${ppdir}/'
	elif	test $($cc -Dprobe -E -tp -h./ -B flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-tp -h${ppdir}/ -B'
	elif	test $($cc -Dprobe -E -t p,./cpp flags.$src | tee cpp.out | grep -c '[-]Dprobe') -eq 1
	then	ppopt='-t p,${ppcmd}'
	else	{
			eval set x $probe_verbose
			shift
			for o in "$@"
			do	$cc -E $o flags.$src
			done
		} 2>&1 | sed -e "s/['\"]//g" > cpp.out
	fi
	;;
*)	if	test `realcppC=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppenv='realcppC=${ppcmd}'
	elif	test `cppC=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppenv='cppC=${ppcmd}'
	elif	test `_CPPNAME=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppenv='_CPPNAME=${ppcmd}'
	elif	test `_CPP=./cpp $cc -Dprobe -E flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppenv='_CPP=${ppcmd}'
	elif	test `$cc -Dprobe -E -%p+. flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1 && test `$cc -Dprobe -E -%p+. flags.$src | wc -l` -eq 1
	then	ppopt='-%p+${ppdir}'
	elif	test `$cc -Dprobe -E -Yp,. flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-Yp,${ppdir}'
	elif	test `$cc -Dprobe -E -Qpath $tmpdir flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-Qpath ${ppdir}'
	elif	test `$cc -Dprobe -E -tp -B./ flags.$src 2>err.out | tee cpp.out | grep -c '[-]Dprobe'` -eq 1 -a ! -s err.out
	then	ppopt='-tp -B${ppdir}/'
	elif	test `$cc -Dprobe -E -B./ flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-B${ppdir}/'
	elif	test `$cc -Dprobe -E -tp -h./ -B flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-tp -h${ppdir}/ -B'
	elif	test `$cc -Dprobe -E -t p,./cpp flags.$src | tee cpp.out | grep -c '[-]Dprobe'` -eq 1
	then	ppopt='-t p,${ppcmd}'
	else	{
			eval set x $probe_verbose
			shift
			for o in "$@"
			do	$cc -E $o flags.$src
			done
		} 2>&1 | sed -e "s/['\"]//g" > cpp.out
	fi
	;;
esac

set x `sed -e 's,[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:\\\\,/,g' -e 's,\\\\,/,g' cpp.out`
def=
definclude="-I+C -I-H"
stdinclude=$definclude
case $hosted in
"")	usrinclude= ;;
esac
cmdinclude=
while	:
do	case $# in
	0|1)	break ;;
	esac
	shift
	case $1 in
	-A)	case $2 in
		*\(*\))	shift
			prepred="$prepred `echo $1 | sed 's/\(.*\)(\(.*\))/\1 \2/'`"
			;;
		esac
		;;
	-A\(*\))
		prepred="$prepred `echo $1 | sed 's/-A\(.*\)(\(.*\))/\1 \2/'`"
		;;
	-[DI][-+][ABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
		stdpp=1
		case $1 in
		-I?[CH])	case $def in
				?*)	definclude="$definclude $1" ;;
				*)	stdinclude="$stdinclude $1" ;;
				esac
				;;
		-I-S*|-YI,*)	usrinclude="`echo $1 | sed 's/....//'`" ;;
		-Y?,*)		;;
		-Y*)		usrinclude="`echo $1 | sed 's/..//'`" ;;
		esac
		;;
	-D)	shift
		case $1 in
		[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_]*=*)
			predef="$predef
`echo $1 | sed -e 's/=.*//'`"
			;;
		[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_]*)
			predef="$predef
$1"
			;;
		esac
		;;
	-Dprobe);;
	-D*)	case $1 in
		-D[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_]*=*)
			predef="$predef
`echo $1 | sed -e 's/^-D//' -e 's/=.*//'`"
			;;
		-D[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_]*)
			predef="$predef
`echo $1 | sed -e 's/^-D//'`"
			;;
		esac
		;;
	-I)	shift
		case $1 in
		/*)	case $def in
			?*)	definclude="$definclude $1" ;;
			*)	stdinclude="$stdinclude $1" ;;
			esac
			cmdinclude="$cmdinclude $1"
			;;
		esac
		;;
	-I/*)	f=`echo X$1 | sed 's/X-I//'`
		case $def in
		?*)	definclude="$definclude $f" ;;
		*)	stdinclude="$stdinclude $f" ;;
		esac
		cmdinclude="$cmdinclude $f"
		;;
	-U)	shift
		undef="$undef $1"
		;;
	-U*)	undef="$undef `echo $1 | sed 's/^-U//'`"
		;;
	flags.$src)def=
		;;
	esac
done
stdinclude="$stdinclude $definclude"
case " $stdinclude " in
*\ $usrinclude\ *)
	case $usrinclude in
	/usr/include)
		usrinclude=
		;;
	*)	case " $stdinclude " in
		*\ /usr/include\ *)
			usrinclude=
			;;
		*)	usrinclude=/usr/include
			;;
		esac
		;;
	esac
	;;
esac

tstinclude=`$cc -v -E flags.$src 2>&1 | sed -e '1,/[iI][nN][cC][lL][uU][dD][eE][ 	]*<[.][.][.]>/d' -e '/^[eE][nN][dD] [oO][fF] [sS][eE][aA][rR][cC][hH]/,\$d'`
j=$tstinclude
case $j in
*/*)	;;
*)	j=$cmdinclude ;;
esac
tstinclude=
good=
nogood=
c_hdr="stdio.h ctype.h"
C_hdr="libc.h"
for i in $j
do	if	test -d "$i"
	then	tstinclude="$tstinclude $i"
		h=
		for f in $c_hdr
		do	if	test -f "$i/$f"
			then	case $i in
				*/CC)	nogood=1 ;;
				*)	good=1 ;;
				esac
			else	h="$h $f"
			fi
		done
		c_hdr=$h
		h=
		for f in $C_hdr
		do	if	test -f "$i/$f"
			then	case $i in
				*/CC)	nogood=1 ;;
				*)	good=1 ;;
				esac
			else	h="$h $f"
			fi
		done
		C_hdr=$h
	fi
done
case $nogood in
1)	good=0 ;;
esac
case $good in
1)	case $c_hdr in
	?*)	bad=1
		usrinclude=/usr/include
		set '' $tstinclude /usr/include
		;;
	*)	set '' $tstinclude
		;;
	esac
	shift
	stdinclude=$*
	echo "#include <sys/types.h>" > include.$src
	$cc -E include.$src | sed -e '/# 1 "[\\/]/!d' -e 's,[^"]*",,' -e 's,[\\/][^\\/]*".*,,' -e 's,[\\/]sys,,' > include.out
	for f in `cat include.out`
	do	if	test -d "$f"
		then	g=`echo $f | sed -e 's,[\\/][\\/]*[^\\/]*$,,'`
			case /$g/ in
			*/tmp/*|*/probe[0123456789]*)
				;;
			*)	case " $stdinclude " in
				*\ $f\ *|*\ $g\ *)
					;;
				*)	stdinclude="$stdinclude $f"
					case $f in
					/usr/include)	usrinclude=$f ;;
					esac
					bad=1
					;;
				esac
				;;
			esac
		fi
	done
	;;
*)	case $ppopt$ppenv in
	?*)	echo '#!'$sh'
		echo $VIRTUAL_ROOT | sed "s/:.*//"' > cpp
		chmod +x cpp
		ppcmd=cpp
		ppdir=.
		eval x='`'$ppenv '$'cc -E $ppopt flags.$src'`'
		case $x in
		?*)	tstinclude=$x/usr/include
			;;
		esac
		cp /bin/echo cpp
		chmod u+w cpp
		;;
	esac

	eval set x $probe_include
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		echo "#include <$1>" > include.$src
		$cc -E include.$src
	done > include.out

	ccinclude=
	x=$stdinclude
	stdinclude=
	subinclude=
	for f in $x $tstinclude `sed -e 's,\\\\,/,g' -e 's,///*,/,g' -e 's,"[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:/,"/,g' -e '/^#[line 	]*[0123456789][0123456789]*[ 	][ 	]*"[\\/]/!d' -e 's/^#[line 	]*[0123456789][0123456789]*[ 	][ 	]*"\(.*\)[\\/].*".*/\1/' include.out | sort -u`
	do	case $f in
		-*)	;;
		*/)	f=`echo $f | sed -e 's,//*\$,,'` ;;
		*/.)	f=`echo $f | sed -e 's,//*.\$,,'` ;;
		esac
		case $f in
		-I*)	;;
		*/cc)	ccinclude=1
			;;
		*/sys)	continue
			;;
		*/include/*/*)
			;;
		*/include/*)
			subinclude="$subinclude $f"
			continue
			;;
		esac
		if	test -d "$f"
		then	case " $stdinclude " in
			*\ $f\ *)	;;
			*)	stdinclude="$stdinclude $f" ;;
			esac
		fi
	done
	rm include.out
	case $ccinclude in
	?*)	eval set x $probe_include
		while	:
		do	shift
			case $# in
			0)	break ;;
			esac
			echo "#include <cc/$1>" > include.$src
			if	$cc -E include.$src > /dev/null
			then	break
			fi
		done
		case $# in
		0)	;;
		*)	x=$stdinclude
			stdinclude=
			for f in $x
			do	case $f in
				*/cc)	;;
				*)	stdinclude="$stdinclude $f" ;;
				esac
			done
			;;
		esac
		;;
	esac
	case $subinclude in
	?*)	for i in $subinclude
		do	for j in $stdinclude
			do	case $i in
				$j/*/*)	;;
				$j/*)	both=
					eval set x $probe_include
					while	:
					do	shift
						case $# in
						0)	for k in $both
							do	echo "#include <$k>" > include.$src
								$cc -E include.$src > include.out
								I=`grep -c $i/$k < include.out`
								J=`grep -c $j/$k < include.out`
								case $I:$J in
								0:*)	;;
								*:0)	stdinclude="$i $stdinclude"
									break
									;;
								esac
							done
							continue 3
							;;
						esac
						if	test -f $i/$1
						then	if	test ! -f $j/$1
							then	break 2
							fi
							both="$both $1"
						fi
					done
					;;
				$j)	continue 2
				;;
				esac
			done
			stdinclude="$i $stdinclude"
		done
		;;
	esac

	{

	for i in $stdinclude
	do
		case $i in
		$usrinclude)	;;
		*)		echo $i $i ;;
		esac
	done

	eval set x $probe_include
	while	:
	do	shift
		case $# in
		0)	break ;;
		esac
		echo "#include <$1>" > t.c
		p=
		for j in `$cc -E t.c | grep "$1" | sed -e 's,\\\\,/,g' -e 's,"[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:/,"/,g' -e '/^#[line 	]*1[ 	][ 	]*"[\\/]/!d' -e 's/^#[line 	]*1[ 	][ 	]*"\(.*\)[\\/].*".*/\1/'`
		do	j=`echo $j | sed -e 's,///*,/,g' -e 's,/$,,'`
			case $p in
			?*)	echo $p $j ;;
			esac
			p=$j
		done
	done

	case $usrinclude in
	?*)	echo $usrinclude $usrinclude ;;
	esac

	} | tsort > tmp.tmp
	tstinclude=`cat tmp.tmp`
	bad=
	for i in $stdinclude
	do	case "
$tstinclude
" in
		*"
$i
"*)			;;
		*)	bad=1
			break
			;;
		esac
	done
	;;
esac

case $bad in
"")	x=$stdinclude
	stdinclude=
	z=
	for i in $tstinclude
	do	case " $x " in
		*" $i "*)
			stdinclude="$stdinclude $i"
			z=$i
			;;
		esac
	done
	case $usrinclude in
	'')	usrinclude=$z ;;
	esac
	;;
esac
case $hosted in
"")	case $usrinclude in
	/usr/include)	usrinclude= ;;
	esac
	;;
esac

case $usrinclude in
?*)	case " $stdinclude " in
	*\ $usrinclude\ *)
		x=$stdinclude
		stdinclude=
		for f in $x
		do	case $f in
			$usrinclude)	;;
			*)		stdinclude="$stdinclude $f" ;;
			esac
		done
		;;
	esac
	;;
esac

# drop dups -- they creep in somehow

x=$stdinclude
stdinclude=
for f in $x
do	case " $stdinclude $usrinclude " in
	*" $f "*)	;;
	*)		stdinclude="$stdinclude $f" ;;
	esac
done
:
# Glenn Fowler
# AT&T Research
#
# @(#)pp.probe (AT&T Research) 2013-09-03
#
# C probe for libpp
#
# NOTE: C.probe must be included or .'d here
#

ppdef=$dir/pp.def
ppkey=$dir/pp.key
ppsym=$dir/ppsym
for f in $ppdef $ppkey $ppsym
do	test -f $f || { echo "$0: $f: not found" >&4; exit 1 ;}
done

sed -e "/^#/d" -e "s/[ 	].*//" < $ppdef > all.pp

system=
release=
version=
architecture=
cpu=
model=
machine=
undef_predef=

#
# path cleanup
#

for i in stdinclude usrinclude
do	eval o='$'$i
	v=$o
	case $v in
	*//*)	v=`echo $v | sed 's,///*,/,g'` ;;
	esac
	if	(test . -ef "`pwd`")
	then	k=
		for x in $v
		do	case $x in
			*/../*|*/..)
				case $x in
				/*)	a=/ ;;
				*)	a= ;;
				esac
				IFS=/
				set '' $x
				IFS=$ifs
				r=
				for d
				do	r="$d $r"
				done
				p=
				g=
				for d in $r
				do	case $d in
					..)	g="$g $d" ;;
					*)	case $g in
						'')	case $p in
							'')	p=$d ;;
							*)	p=$d/$p ;;
							esac
							;;
						*)	set $g
							shift
							g=$*
							;;
						esac
						;;
					esac
				done
				case $a in
				'')	for d in $g
					do	p=$d/$p
					done
					;;
				*)	p=$a$p
					;;
				esac
				case $p in
				/)	continue ;;
				esac
				test $x -ef $p && x=$p
				;;
			esac
			k="$k $x"
		done
		set '' $k
		shift
		v=$1
		case $# in
		0)	;;
		*)	shift
			while	:
			do	case $# in
				0)	break ;;
				esac
				k=
				for d
				do	for j in $v
					do	test $d -ef $j && continue 2
					done
					k="$k $d"
				done
				set '' $k
				case $# in
				1)	break ;;
				esac
				shift
				v="$v $1"
				shift
			done
			;;
		esac
	fi
	case $v in
	$o)	;;
	*)	eval $i='$'v ;;
	esac
done

id="::IDENT::`date`::IDENT::"
echo '#assert test(ok)
#if #test(ok)
#else
(
#endif' > assert.$src
echo '#ifdef __BASE_FILE__
int ok;
#else
(
#endif' > basefile.$src
cat > catlit1.i <<'!'
char test[] = "te"
"st";
!
cat > catlit2.i <<'!'
char test[] = "te\
st";
!
echo '#define g(a,b) a ## b
volatile int a;
const int g(x,y)=1;
extern int c(int);' > compat.$src
echo > cpp.$src
echo "#defincl <x.h>" > defincl.$src
echo 'int a$b;' > dollar.$src
echo "#eject" > eject.$src
echo "#if 0
(
#else if 1
int x;
#else
(
#endif" > elseif.$src
echo "#define _CAT(a,b,c) a##b##c
#define hdra	hdrx
#define hdr	_CAT(<,hdra,.h>)
#include hdr" > hdra.$src
echo "#define _XAT(a,b,c) a##b##c
#define _CAT(a,b,c) _XAT(a,b,c)
#define hdra	hdrx
#define hdr	_CAT(<,hdra,.h>)
#include hdr" > hdrx.$src
echo "int f(){return 0;}" > hdrx.h
echo "#ident \"$id\"" > ident.$src
echo "#import \"import.h\"" > import.$src
echo "int aaa;" > import.h
echo "#include <inc_next.h>" > inc_next.$src
mkdir inc0 inc1
echo "#include_next <inc_next.h>" > inc0/inc_next.h
echo 'char s[] = "INCLUDE_NEXT";' > inc1/inc_next.h
echo '# 1 "linefile.i"

# 1 "linefile.i"

int i;' > linefile1.i
echo '# 1 "linefile.i"

# 1

int i;' > linefile2.i
echo "int i = 0;" > lineid1.i
echo '# 1 "t.c"
int i = 0;' > lineid2.i
echo '# 1 "t.c"
int i = 0;' > lineid3.$src
echo "#include <stdio.h>" > linetype.$src
echo '#include <sys/types.h>
main()
{
	return sizeof(LONGLONG) != 8;
}' > longlong.$src
echo '#include "once.h"
#include "once.h"' > once.$src
echo '#ifdef once
allmultiple
#else
#define once
#endif' > once.h
echo "extern int a,b;int f(){return a + = b;}" > opspace.$src
echo "int f(){return(0);} // ((" > pluscom.$src
echo "class x {int n;} m;" > plusplus.$src
echo > preinc.$src
echo '// splice \
(
int x = 1;' > plusspl.$src
echo "int stdc_default_value = __STDC__ ;" > stdc.$src
echo 'char xxx[] = "abc
(";' > span.$src
echo '#define g(a,b) a\
b
int ab,xy;
#define xy XY
char* g(x,y);' > splice.$src
{
echo 'int a\                        '
echo 'b = 1;'
} > splicesp.$src
echo '#define g(a,b) a/**/b
int g(x,y)=1;' > trans.$src
echo '#define m 65
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 65
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 64
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 63
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 62
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 61
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 60
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 59
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 58
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 57
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 56
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 55
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 54
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 53
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 52
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 51
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 50
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 49
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 48
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 47
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 46
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 45
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 44
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 43
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 42
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 41
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 40
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 39
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 38
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 37
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 36
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 35
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 34
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 33
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 32
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 31
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 30
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxxx 29
#define xxxxxxxxxxxxxxxxxxxxxxxxxxxx 28
#define xxxxxxxxxxxxxxxxxxxxxxxxxxx 27
#define xxxxxxxxxxxxxxxxxxxxxxxxxx 26
#define xxxxxxxxxxxxxxxxxxxxxxxxx 25
#define xxxxxxxxxxxxxxxxxxxxxxxx 24
#define xxxxxxxxxxxxxxxxxxxxxxx 23
#define xxxxxxxxxxxxxxxxxxxxxx 22
#define xxxxxxxxxxxxxxxxxxxxx 21
#define xxxxxxxxxxxxxxxxxxxx 20
#define xxxxxxxxxxxxxxxxxxx 19
#define xxxxxxxxxxxxxxxxxx 18
#define xxxxxxxxxxxxxxxxx 17
#define xxxxxxxxxxxxxxxx 16
#define xxxxxxxxxxxxxxx 15
#define xxxxxxxxxxxxxx 14
#define xxxxxxxxxxxxx 13
#define xxxxxxxxxxxx 12
#define xxxxxxxxxxx 11
#define xxxxxxxxxx 10
#define xxxxxxxxx 9
#define xxxxxxxx 8
#define xxxxxxx 7
#define xxxxxx 6
#define xxxxx 5
#define xxxx 4
#define xxx 3
#define xx 2
#define x 1
#if xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx != m
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#endif' > truncate.$src
cat > zeof.c <<'!'
char* foo = "az";
!

allmultiple=
assert=
basefile=
compatibility=1
defincl=
dollar=
eject=
elseif=
headerexpand=
headerexpandall=
hostedtransition=
ident=
import=
include_next=
linefile=
lineid=
linetype=
nocatliteral=
opspace=
pluscom=
plusplus=
plussplice=
redef=
reguard=
reserved=
spaceout=
splicecat=
splicespace=
strict=
stringspan=
transition=
truncate=
zeof=

$cc -c assert.$src && assert=1

$cc -c basefile.$src && basefile=__BASE_FILE__

if	$cc -E defincl.$src
then	case "`$cc -E defincl.$src | grep -c 'defincl'`" in
	0)	defincl=1 ;;
	esac
fi

if	$cc -c catlit1.i 2>e
then	if	$cc -c catlit2.i 2>f
	then	if	test `wc -c < f` -gt `wc -c < e`
		then	nocatliteral=1
		fi
	else	nocatliteral=1
	fi
fi

$cc -c dollar.$src && dollar=1

$cc -c elseif.$src && elseif=1

if	$cc -I. -c hdra.$src
then	headerexpandall=1
elif	$cc -I. -c hdrx.$src
then	headerexpand=1
fi

if	$cc -E eject.$src
then	case "`$cc -E eject.$src | grep -c 'eject'`" in
	0)	eject=1 ;;
	esac
fi

$cc -S ident.$src && grep "$id" ident.s && ident=1

{ $cc -E import.$src | grep aaa ;} && import=1

{ $cc -E -Iinc0 -Iinc1 inc_next.$src | grep INCLUDE_NEXT ;} && include_next=1

if	$cc -c linefile1.i
then	$cc -c linefile2.i
	case $? in
	0)	;;
	*)	linefile=1 ;;
	esac
fi

if	$cc -c lineid1.i 2>b
then	$cc -c lineid2.i 2>e
	c=$?
else	$cc -c lineid3.c 2>e
	c=$?
fi
case $c in
0)	case `wc -l < b` in
	`wc -l < e`)	;;
	*)		lineid=line ;;
	esac
	;;
*)	lineid=line
	;;
esac

if	$cc -E linetype.$src | grep '^[ 	]*#[ 	]*[0123456789]*[ 	]*".*"[ 	]*[12]' > linetype
then	if	grep '^[ 	]*#[ 	]*[0123456789]*[ 	]*".*"[ 	]*[12][ 	][ 	]*3' linetype
	then	linetype=2
	else	linetype=1
	fi
fi

{ $cc -E once.$src | grep allmultiple ;} && allmultiple=1

$cc -c plusplus.$src && plusplus=1

$cc -c span.$src && stringspan=1

$cc -c splice.$src && splicecat=1

$cc -c splicesp.$src && splicespace=1

exec < $ppkey
while	read keyword type alternate comment
do	case $keyword in
	.)	break ;;
	""|"#")	continue ;;
	esac
	case $type in
	""|".")	type= ;;
	*)	type="=$type" ;;
	esac
	for pre in '' _ __
	do	for suf in '' _ __
		do	case $suf in
			'')	sep= ;;
			*)	sep=. ;;
			esac
			case ,,$alternate, in
			*,$pre$sep$suf,*)
				key=$pre$keyword$suf
				undef="$undef $key"
				echo "int f(){
	int	$key = 0;
	return $key;
}
#undef	$key
int g(){
	int	$key = 0;
	return $key;
}" > key.$src
				$cc -c key.$src >/dev/null 2>&1 || reserved="$reserved $key$type"
				;;
			esac
		done
	done
done

$cc -c opspace.$src && opspace=1

case $plusplus in
"")	$cc -c compat.$src && compatibility=
	$cc -c pluscom.$src && pluscom=1
	;;
esac
case $plusplus$pluscom in
?*)	$cc -c plusspl.$src || plussplice=1 ;;
esac
case $plusplus in
?*)	mkdir reguard
	cd reguard
	echo '#include "ptrone.h"
#include "ptrdef.h"
int main () { return gt(2,1) + gt(2.0,1.0); }' > ptr.$src
	echo '#include "ptrone.h"
template<class T> int gt(T a, T b) { return a > b; }' > ptrdef.$src
	echo 'template<class T> int gt(T a, T b);' > ptrdef.h
	echo '/* empty */' > ptrone.h
	if	$cc -E ptr.$src > x.i && $cc x.i
	then	echo '#ifndef _PTRONE_H
#define _PTRONE_H
static int xxx;
#endif' > ptrone.h
		if	$cc -E ptr.$src > x.i && echo "#define _PTRONE_H" >> x.i && $cc x.i
		then	reguard=1
		fi
	fi
	cd ..
	rm -rf reguard
	;;
esac

stdc=`$cc -E stdc.$src | sed -e '/stdc_default_value/!d' -e 's/.*=[ 	]*//' -e 's/[ 	]*;.*//'`
case $stdc in
0)		$cc -c trans.$src && transition=1 ;;
[0123456789]*)	;;
*)		stdc= ;;
esac

truncate=`$cc -E truncate.$src | grep '^[ 	]*[0123456789]'`
$cc -c zeof.c || zeof=1

echo "$predef" >> all.pp
{
	case $ppopt$ppenv in
	?*)	ppcmd=cpp
		ppdir=.
		eval $ppenv '$'cc -Dmycpp -E '$'ppopt cpp.$src
		;;
	esac
	eval set x $probe_verbose
	shift
	x=
	for o in "$@"
	do	set x `$cc $o -c cpp.$src 2>&1`
		while	:
		do	shift
			case $# in
			0)	break ;;
			esac
			case $1 in
			*[\\/]rm)
				;;
			[\\/]*)	case " $x " in
				*" $1 "*)	;;
				*)		test -f $1 && test -x $1 && x="$x $1" ;;
				esac
				;;
			esac
		done
		case $x in
		?*)	for f in $x
			do	cp $f x && chmod u+w x && strip x && f=x
				$ppsym < $f
			done
			break
			;;
		esac
	done
} 3>&- 3>&1 >/dev/null |
	sed -e '/^ppsymbol$/d' -e '/^.$/d' -e '/^..$/d' -e '/[ABCDEFGHIJKLMNOPQRSTUVWXYZ].*[abcdefghijklmnopqrstuvwxyz]/d' -e '/[abcdefghijklmnopqrstuvwxyz].*[ABCDEFGHIJKLMNOPQRSTUVWXYZ]/d' |
	cat - all.pp |
	sort -u |
	{
	for i in 0 1 2 3 4 5
	do	echo "struct { char* name; long value; } predef[] = {" > cpp$i.$src
	done
	while read sym junk
	do	case $sym in
		_*)	set 0 ${sym}
			;;
		*_)	continue
			;;
		[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
			set 1 ${sym} 2 _${sym} 3 _${sym}_ 4 __${sym} 5 __${sym}__
			;;
		*)	continue
			;;
		esac
		while	:
		do	case $# in
			0|1)	break ;;
			esac
			{
			echo "#ifdef $2"
			echo "\"$2\" , (long) $2 -1,"
			echo "#endif"
			} >> cpp$1.$src
			shift
			shift
		done
	done 
	for i in 0 1 2 3 4 5
	do	echo "\"\", 0 };" >> cpp$i.$src
	done
	}
preval="`for i in 0 1 2 3 4 5;do $cc -E cpp$i.$src;done | sed -e '/\".*\".*,.*,/!d' -e 's/[^\"]*\"\\([^\"]*\\)\"[ 	]*,[ 	]*([ 	]*long[ 	]*)[ 	]*\\(.*\\)[ 	]*-[ 	]*1[ 	]*,[ 	]*\$/\\1 \\2 =/g' -e '/\\(^[^ ]*\\) \1  *=$/d'` `$cc -dM -E stdc.$src | sed -e '/[ 	]*#[ 	]*define/!d' -e '/\"/d' -e 's/[ 	]*#[ 	]*define[ 	]*\\([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*([^)]*)\\)[ 	]*\\(.*\\)/\\1 \\2 =/' -e 's/[ 	]*#[ 	]*define[ 	]*\\([abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_]*\\)[ 	]*\\(.*\\)/\\1 \\2 =/'`"
	print -r "$preval" > /tmp/probe/preval

for i in bufld namei quota reboot utsname vfs
do	echo "#include <sys/$i.h>" > t.$src
	if	$cc -E t.$src
	then	x=1
	else	x=0
	fi
	eval sys_$i=$x
done

echo "char* fun() { return (char*)__FUNCTION__; }
int main() { return !fun(); }" > fun.$src
rm -f fun.exe
if	$cc -o fun.exe fun.$src && test -x fun.exe
then	undef_predef="$undef_predef __FUNCTION__"
fi

case "`grep -c '__STDC__[-0 	]*[=!]=[ 	]*0' $usrinclude/stdio.h 2>/dev/null`" in
0)	;;
*)	hostedtransition=1 ;;
esac

mapinclude=
for i in builtins
do	echo "#include <$i.h>" > t.$src
	if	$cc -E t.$src
	then	mapinclude="$mapinclude <$i.h>=\".\""
	fi
done

#
# the payoff
#

exec >&3

case "$compatibility:$transition:$dollar" in
::)	strict=1 ;;
esac
case $version_stamp in
?*)	echo "/* $version_stamp" ;;
*)	echo "/* $cc" ;;
esac
echo "*/"
case $plusplus:$stdc in
1:?*)	preval="$preval = __STDC__ $stdc ="
	redef="$redef __STDC__"
	;;
esac
ppbuiltin=0
set x $preval
shift
case $# in
0)	;;
*)	echo
	echo "#pragma pp:predefined"
	predef=
	while	:
	do	case $# in
		0)	break ;;
		esac
		m=$1
		shift
		case $m in
		*'('*)	i=`echo "$m" | sed 's,(.*,,'` ;;
		*)	i=$m ;;
		esac
		predef="$predef
$i"
		eval predef_$i=0
		while	:
		do	case $1 in
			'=')	break ;;
			*)	shift ;;
			esac
		done
		while	:
		do	case $1 in
			'=')	shift ;;
			*)	break ;;
			esac
		done
	done
	for i in $undef
	do	case " $redef " in
		*" $i "*)	;;
		*)		eval predef_$i=3 ;;
		esac
	done
	set $preval
	while	:
	do	case $# in
		0)	break ;;
		esac
		m=$1
		shift
		case $m in
		*'('*)	i=`echo "$m" | sed 's,(.*,,'` ;;
		*)	i=$m ;;
		esac
		case $i in
		'=')	continue ;;
		esac
		v=
		while	:
		do	case $1 in
			'=')	break ;;
			esac
			v="$v $1"
			shift
		done
		while	:
		do	case $1 in
			'=')	shift ;;
			*)	break ;;
			esac
		done
		case $i in
		__LCC__)strict=2 ;;
		_*)	;;
		*)	eval j=\$predef_$i
			case $j in
			0)	eval predef_$i=1
				echo "#define $m$v"
				case $strict in
				1)	strict= ;;
				esac
				;;
			esac
			;;
		esac
	done
	nopredef=0
	while	:
	do	set $preval
		while	:
		do	case $# in
			0)	break ;;
			esac
			m=$1
			shift
			case $m in
			*'('*)	i=`echo "$m" | sed 's,(.*,,'` ;;
			*)	i=$m ;;
			esac
			v=
			while	:
			do	case $1 in
				'=')	break ;;
				esac
				v="$v $1"
				shift
			done
			while	:
			do	case $1 in
				'=')	shift ;;
				*)	break ;;
				esac
			done
			case $m in
			__*_BIT__|__*_DIG__|__*_MIN__|__*_MAX__|__*_TYPE__|*_FLT_*|*_DBL_*|*_LDBL_*)
				case $nopredef in
				0)	nopredef=1
					continue
					;;
				1)	continue
					;;
				esac
				;;
			esac
			case $nopredef in
			2)	;;
			*)	case $v in
				' '*' '*)
					nopredef=1
					continue
					;;
				' '[0123456789]*|' '"'"*"'"*)
					;;
				*)	case $1 in
					_*)	;;
					*)	nopredef=1
						continue
						;;
					esac
					;;
				esac
				;;
			esac
			eval j=\$predef_$i
			case $j in
			0)	case $ppbuiltin in
				2)	echo "#pragma pp:builtin"
					ppbuiltin=1
					;;
				esac
				eval predef_$i=2
				echo "#define $m$v"
				;;
			1)	case $m in
				$i)	eval predef_$i=2
					eval j=\$predef___${i}__
					case $j in
					[12])	;;
					*)	case $ppbuiltin in
						2)	echo "#pragma pp:builtin"
							ppbuiltin=1
							;;
						esac
						eval predef___${i}__=2
						echo "#define __${i}__$v"
						;;
					esac
					;;
				esac
				;;
			esac
		done
		case $nopredef in
		2)	break ;;
		esac
		echo "#pragma pp:nopredefined"
		case $nopredef in
		0)	break ;;
		esac
		ppbuiltin=2
		nopredef=2
	done
	;;
esac
case $basefile in
?*)	case $ppbuiltin in
	0|2)	ppbuiltin=1
		echo "#pragma pp:builtin"
		;;
	esac
	echo "#define $basefile	#(BASE)"
	;;
esac
case $ppbuiltin in
1)	echo "#pragma pp:nobuiltin" ;;
esac

eval set x $probe_longlong
shift
x=
for o in "$@"
do	rm -f longlong.$exe
	if	$cc -DLONGLONG="$o" -o longlong.$exe longlong.$src &&
		./longlong.$exe
	then	x=1
		break
	fi
done
case $x in
'')	eval set x $probe_longlong_t
	shift
	for o in "$@"
	do	rm -f longlong.$exe
		if	$cc -DLONGLONG="$o" -o longlong.$exe longlong.$src &&
			./longlong.$exe
		then	echo "#define <long long> $o"
			break
		fi
	done
	;;
esac

echo
for i in `echo "$predef" | sed -e 's/^__*\(.*\)_*\$/\1/' -e '/^[abcdefghijklmnopqrstuvwxyz][abcdefghijklmnopqrstuvwxyz]*[0123456789][abcdefghijklmnopqrstuvwxyz0123456789]*\$/!d'` `echo "$predef" | sed -e 's/^__*\(.*\)_*\$/\1/' -e '/^[abcdefghijklmnopqrstuvwxyz][abcdefghijklmnopqrstuvwxyz]*\$/!d'`
do	case $i in
	*ix)	;;
	*)	architecture=$i
		break
		;;
	esac
done
for i in `sed -e '/^#/d' -e '/:architecture:/!d' -e 's/[ 	].*//' < $ppdef`
do	eval j="\" \$predef_$i \$predef__${i} \$predef__${i}_ \$predef___${i} \$predef___${i}__ \""
	case $j in
	*" 2 "*)architecture=$i
		break
		;;
	esac
done
for i in `sed -e '/^#/d' -e '/:machine:/!d' -e 's/[ 	].*//' < $ppdef`
do	eval j="\" \$predef_$i \$predef__${i} \$predef__${i}_ \$predef___${i} \$predef___${i}__ \""
	case $j in
	*" 2 "*)machine="$machine $i" ;;
	esac
done
case $sys_bufld$sys_reboot$sys_utsname in
1??)	release=research
	version=9
	;;
01?)	release=bsd
	case $sys_quota in
	0)	case $sys_vfs in
		0)	version=4.1
			;;
		esac
		;;
	1)	case $sys_namei in
		0)	version=4.2
			;;
		1)	version=4.3
			;;
		esac
		;;
	esac
	;;
001)	release=V
	;;
esac
for i in `sed -e '/^#/d' -e '/:release:/!d' -e 's/[ 	].*//' < $ppdef`
do	eval j=\$predef_$i
	case $j in
	2)	release="$release $i" ;;
	esac
done
for i in `sed -e '/^#/d' -e '/:system:/!d' -e 's/[ 	].*//' < $ppdef`
do	eval j=\$predef_$i
	case $j in
	2)	system="$system $i" ;;
	esac
done
case $release in
topix)	release="$release V"
	;;
esac
case $assert in
?*)	for i in $predef
	do	case $i in
		_*|*_)	;;
		*)	for p in architecture cpu machine system
			do	echo "#if #$p($i)
eval \"case \\\" \$$p \\\" in *\\\" $i \\\"*) ;; *) $p=\\\"$i \$$p\\\" ;; esac\"
: avoid string literal concatenation
#endif"
			done
			;;
		esac
	done > t.$src
	eval "`$cc -E t.$src`"
	set x x $prepred
	while	:
	do	shift
		shift
		case $# in
		[01])	break ;;
		esac
		eval "
			case \" \$$1 \" in
			*\" $2 \"*) ;;
			*) $1=\"$2 \$$1\" ;;
			esac
		"
	done
	;;
esac
case $system in
"")	system=unix ;;
esac
case $architecture in
ibm|uts|u370)	model=370
		architecture=ibm
		;;
m*68*)		architecture=m68000
		for i in $predef
		do	case $i in
			m*68*[123456789][0123456789])
				model=`echo $i | sed 's/.*\(..\)/\1/'`
				break
				;;
			esac
		done
		;;
u3b?*)		model=`echo $architecture | sed 's/u3b//'`
		architecture=3b
		;;
u3b)		case $model in
		"")	model=20 ;;
		esac
		architecture=3b
		;;
vax[0123456789]*)
		model=`echo $architecture | sed 's/vax//'`
		architecture=vax
		;;
hp[0123456789]*s[0123456789])
		case $release in
		[abcdefghijklmnopqrstuvwxyz]*.[abcdefghijklmnopqrstuvwxyz]*.*)
			version=$release
			release=V
			;;
		esac
		architecture="$architecture `echo $architecture | sed 's/s.*//'`"
		;;
esac
case $hosttype in
*.*)	i=`echo $hosttype | sed -e 's,.*\.,,'` ;;
*)	i=$hosttype ;;
esac
case $i in
unknown);;
?*)	case " $architecture " in
	*" $i "*) ;;
	*)	architecture="$architecture $i" ;;
	esac
	;;
esac
case $architecture in
"")	echo "$cc: warning: architecture not determined" >&4
	set x $machine
	architecture=$2
	;;
esac
echo "#define #hosttype($hosttype)"
for i in $system
do	echo "#define #system($i)"
done
case $release in
"")	echo "#define #release()" ;;
*)	for i in $release
	do	echo "#define #release($i)"
		case $i in
		V)	echo "#define #release(system5)" ;; # compatibility
		esac
	done
	;;
esac
echo "#define #version($version)"
case $architecture in
"")	echo "#define #architecture()" ;;
*)	for i in `echo $architecture | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz`
	do	echo "#define #architecture($i)"
	done
	;;
esac
echo "#define #model($model)"
case $machine in
"")	case $architecture:$model in
	?*:?*)	set x $architecture; machine="$2/$model $architecture" ;;
	*)	machine=$architecture ;;
	esac
	;;
*)	machine="$machine $architecture"
	;;
esac
case $machine in
"")	echo "#define #machine()" ;;
*)	j=
	for i in `echo $machine | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz`
	do	case " $i " in
		*" $j "*)
			;;
		*)	j="$j $i"
			echo "#define #machine($i)"
			;;
		esac
	done
	;;
esac
for i in $cpu
do	echo "#define #cpu($i)"
done
echo "#define #addressing()"
for i in $ATTRIBUTES
do	eval d=\$$i
	n=`echo $i | tr ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz`
	echo "#define #$n($d)"
done
case $stdc in
?*)	echo "#define #dialect(ansi)" ;;
esac
case $plusplus in
?*)	echo "#define #dialect(C++)" ;;
esac
case $hosted in
"")	echo "#define #dialect(cross)" ;;
esac
case $so:$dynamic:$static in
::)	;;
*)	echo "#define #dialect(dynamic)" ;;
esac
echo
case $undef_predef in
?*)	for m in $undef_predef
	do	echo "#undef	$m"
	done
	echo
	;;
esac
case $plusplus in
?*)	echo "#pragma pp:plusplus" ;;
esac
case $reserved in
?*)	echo "#pragma pp:reserved" $reserved ;;
esac
case $nocatliteral in
?*)	echo "#pragma pp:nocatliteral" ;;
esac
case $opspace in
?*)	echo "#pragma pp:opspace" ;;
esac
case $pluscom in
?*)	echo "#pragma pp:pluscomment" ;;
esac
case $plussplice in
?*)	echo "#pragma pp:plussplice" ;;
esac
case $reguard in
?*)	echo "#pragma pp:reguard" ;;
esac
case $splicecat in
?*)	echo "#pragma pp:splicecat" ;;
esac
case $splicespace in
?*)	echo "#pragma pp:splicespace" ;;
esac
case $stringspan in
?*)	echo "#pragma pp:stringspan" ;;
esac
case $stdc in
"")	echo "#pragma pp:compatibility"
	;;
0)	echo "#pragma pp:transition"
	;;
1)	case $strict in
	?*)	echo "#pragma pp:strict" ;;
	esac
	;;
esac
case $hostedtransition in
1)	echo "#pragma pp:hostedtransition" ;;
esac
case $stdc in
?*)	case $ppopt$ppenv in
	"")	spaceout=1
		echo "#pragma pp:spaceout"
		;;
	esac
	;;
esac
case $truncate in
?*)	echo "#pragma pp:truncate $truncate" ;;
esac
case $zeof in
?*)	echo "#pragma pp:zeof" ;;
esac
case $dollar in
1)	echo '#pragma pp:id "$"' ;;
esac
cdir=-I+C
hdir=-I+H
set x $stdinclude
while	:
do	shift
	case $# in
	0)	break ;;
	esac
	case $1 in
	$cdir|$hdir)
		;;
	-I+C)	cdir=$1
		echo "#pragma pp:nocdir"
		;;
	-I-C)	cdir=$1
		echo "#pragma pp:cdir"
		;;
	-I+H)	hdir=$1
		echo "#pragma pp:nohostdir"
		;;
	-I-H)	hdir=$1
		echo "#pragma pp:hostdir"
		;;
	-I*)	;;
	*)	echo "#pragma pp:include \"$1\""
		;;
	esac
done
case $usrinclude in
/usr/include)
	;;
?*)	echo "#pragma pp:standard \"$usrinclude\""
	;;
esac
case $plusplus in
?*)	case $usrinclude in
	?*)	if	grep plusplus $usrinclude/ctype.h >/dev/null 2>&1
		then	echo '#pragma pp:nocdir "-"'
		fi
		;;
	esac
	;;
esac
case $mapinclude in
?*)	echo "#pragma pp:mapinclude hosted$mapinclude" ;;
esac
case $linefile in
?*)	echo "#pragma pp:linefile" ;;
esac
case $lineid in
?*)	echo "#pragma pp:lineid line" ;;
esac
case $linetype in
1)	echo "#pragma pp:linetype" ;;
?*)	echo "#pragma pp:linetype $linetype" ;;
esac
case $allmultiple in
"")	echo "#pragma pp:noallmultiple" ;;
esac
case $defincl in
1)	echo '#pragma pp:map "/#(pragma )?defincl>/"' ;;
esac
case $eject in
1)	echo '#pragma pp:map "/#(pragma )?eject>/"' ;;
esac
case $elseif in
1)	echo "#pragma pp:elseif" ;;
esac
case $headerexpand in
1)	echo "#pragma pp:headerexpand" ;;
esac
case $headerexpandall in
1)	echo "#pragma pp:headerexpandall" ;;
esac
case $ident in
1)	echo '#pragma pp:map "/#(pragma )?ident>/" "/#(pragma )?/###/"' ;;
*)	echo '#pragma pp:map "/#(pragma )?ident>/"' ;;
esac
case $import in
1)	echo '#pragma pp:map "/#(pragma )?import>/" "/#(pragma )?import(.*)/__STDPP__IMPORT__(\2)/"
#macdef __STDPP__IMPORT__(x)
#pragma pp:noallmultiple
#include x
#pragma pp:allmultiple
#endmac' ;;
esac
case $include_next in
1)	echo '#pragma pp:map "/#include_next>/" ",[^\<]*\<,#include <.../,"' ;;
esac
echo '#pragma pp:map "/#pragma lint:/" ",#pragma lint:(.*),##/*\1*/,u"'
echo '#pragma pp:map "/#(pragma )?sccs>/"'

case $stdc:$spaceout in
1:)	case ' '$reserved' ' in
	*' 'asm' '*|*' 'asm=*)
		echo "#macdef asm"
		echo "#pragma pp:spaceout"
		echo "#undef asm"
		echo "asm"
		echo "#endmac"
		;;
	esac
	;;
esac

if	$cc -E preinc.$src > preinc.out
then	for f in `sed -e 's,\\\\,/,g' -e 's,"[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]:/,"/,g' -e '/^#[line 	]*[0123456789][0123456789]*[ 	][ 	]*"[\\/]/!d' -e 's/^#[line 	]*[0123456789][0123456789]*[ 	][ 	]*".*[\\/]\(.*\)".*/\1/' preinc.out | sort -u`
	do	case $f in
		*preinc.$src*)
			;;
		*)	echo "#include <$f>"
			;;
		esac
	done
fi
