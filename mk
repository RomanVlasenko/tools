#!/bin/bash

if [ -z "$PROJECT_FOLDER" ]
then
    echo "Environment variable PROJECT_FOLDER needs to be specified"
    exit 1
fi

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
    echo "-c    compiles maven target with 'clean' phase"
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
        mvn -f $PROJECT_FOLDER/$arg/pom.xml "$CLEAN_TARGET"install $SKIP_TESTS >> output.log
        ((COMPLETED_COUNTER++))
        echo -ne "Completed $COMPLETED_COUNTER of $ARG_COUNTER\r"
        sleep 1
        ;;
  esac
done

echo -ne ''
echo "SUCCESS!                 "