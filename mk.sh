#!/bin/bash

PROJECT_FOLDER=/home/rvl/projects/worldticket/maven

SKIP_TESTS=-DskipTests
CLEAN_TARGET=

ARG_COUNTER=0;

for arg in "$@"
do
    case $arg in
    -*) #DO NOTHING
		;;
    *) ((ARG_COUNTER++))
		;;
  esac
done

if [ $ARG_COUNTER=0 ]
then
	ME=`basename $0`
	echo "$ME [OPTION]... (MODULE1 MODULE2)..."
	echo $'Compiles maven modules in specified order\n'
	echo $'Skips tests and targets cleaning by default\n'
	echo "Options:"
	printf "%s %s" "$*compiles maven target with 'clean' phase"
	echo "-c    "
	echo "-t    compiles maven target with 'test' phase"
	exit 0
fi

COMPLETED_COUNTER=0;

for arg in "$@"
do
    case $arg in
    -c|-C)
    	CLEAN_TARGET="clean "
    	;;
    -t|-T)
    	SKIP_TESTS=
    	;;
    -*)
    	echo "Invalid option: -$OPTARG"
    	;;
    *)
    	echo "Compile and test $arg..."
    	echo mvn -f $PROJECT_FOLDER/$arg/pom.xml "$CLEAN_TARGET"install $SKIP_TESTS >> output.log
    	((COMPLETED_COUNTER++))
		echo -ne "Completed: $((100-100/$COMPLETED_COUNTER))%\r"
		sleep 1
    	;;
  esac
done

echo -ne ''
echo "SUCCESS!                 "