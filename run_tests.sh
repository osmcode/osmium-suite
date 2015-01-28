#!/bin/sh
#
#  run_tests.sh
#

# the compiler/c++ version combinations to test
COMPILERS="clang++-3.5,c++11 g++-4.9,c++11 clang++-3.4,c++11 g++-4.8,c++11 clang++,c++14 g++-4.9,c++14"
#COMPILERS="clang++,c++11"
#COMPILERS="g++-4.9,c++11 g++-4.8,c++11"

THIS_DIR=`pwd`

DATE=`date +'%Y%m%dT%H%M'`

exec >testrun-$DATE.log 2>&1
set -e

BOLD="\033[1m"
NORM="\033[0m"
GREEN="\033[1;32m"
DARKRED="\033[31m"
RED="\033[1;31m"

msg() {
    date=`date +'%Y-%m-%dT%H:%M:%S'`
    echo "$DARKRED$BOLD==== $date $*$NORM"
}

has_cmake_tests() {
    num_tests=`ctest --show-only | tail -1 | cut -d: -f2`
    [ "$num_tests" != " 0" ]
}

test_using_cmake() {
    REPOS=$1
    BUILD_DIR="build-test-${DATE}-${CXX}-${CPP_VERSION}"
    msg "Tests: $REPOS...\n"
    cd $REPOS

    set -x
    mkdir $BUILD_DIR
    cd $BUILD_DIR
    cmake -L -DCMAKE_BUILD_TYPE=Dev -DUSE_CPP_VERSION=$CPP_VERSION $CMAKE_OPTIONS ..
    make VERBOSE=1

    # run internal tests
    has_cmake_tests && ctest -V

    # run external tests
    test_script="${THIS_DIR}/${REPOS}-tests.sh"
    [ -e $test_script ] && $test_script

    cd ..
    rm -fr $BUILD_DIR
    set +x

    cd ..
    msg "Tests: $REPOS done\n"
}

cd ..

msg START

for compiler in $COMPILERS; do
    CXX=${compiler%,*}
    CPP_VERSION=${compiler#*,}
    msg "Using compiler $CXX and version $CPP_VERSION..."

    CMAKE_OPTIONS="-DBUILD_HEADERS=ON"
    test_using_cmake libosmium

    CMAKE_OPTIONS=""
    test_using_cmake osmium-tool
    test_using_cmake osmium-contrib
done

msg DONE

