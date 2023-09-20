#!/bin/sh
#
#  run_tests.sh
#

# the compiler/c++ version combinations to test
COMPILERS="g++-8,c++11 clang++-6,c++11 g++-8,c++14 clang++-8,c++11 clang++-8,c++14"

if [ -z "$OSMIUM_TEST_BUILD_ROOT" ]; then
    OSMIUM_TEST_BUILD_ROOT='.'
fi

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
    CURRENT_DIR=`pwd`
    REPOS=$1
    CMAKE_OPTIONS=$2

    BUILD_DIR="${OSMIUM_TEST_BUILD_ROOT}/build-test-$REPOS-${DATE}-${CXX}-${CPP_VERSION}"
    msg "Repository $REPOS: Configuring..."

    SOURCE_DIR=`pwd`/$REPOS
    mkdir $BUILD_DIR
    cd $BUILD_DIR
    cmake -L -DCMAKE_BUILD_TYPE=Dev -DUSE_CPP_VERSION=$CPP_VERSION $CMAKE_OPTIONS $SOURCE_DIR

    msg "Repository $REPOS: Building..."
    make VERBOSE=1

    msg "Repository $REPOS: Testing..."
    # run internal tests
    has_cmake_tests && ctest --output-on-failure

    cd ..
    rm -fr $BUILD_DIR

    msg "Repository $REPOS: done\n"
    cd $CURRENT_DIR
}

test_using_make() {
    CURRENT_DIR=`pwd`
    REPOS=$1

    BUILD_DIR="${OSMIUM_TEST_BUILD_ROOT}/build-test-$REPOS-${DATE}-${CXX}-${CPP_VERSION}"

    msg "Repository $REPOS: Configuring..."

    SOURCE_DIR=`pwd`/$REPOS
    mkdir $BUILD_DIR
    cd $BUILD_DIR
    ln -s "$SOURCE_DIR/../libosmium"
    ln -s "$SOURCE_DIR/../protozero"
    git clone $SOURCE_DIR $REPOS
    cd $REPOS

    msg "Repository $REPOS: Building..."
    make VERBOSE=1

#    msg "Repository $REPOS: Testing..."
#    make test

    cd ../..
    rm -fr $BUILD_DIR

    msg "Repository $REPOS: done\n"
    cd $CURRENT_DIR
}

test_python() {
    CURRENT_DIR=`pwd`
    REPOS=$1
    PYTHON=$2

    BUILD_DIR="${OSMIUM_TEST_BUILD_ROOT}/build-test-$REPOS-${DATE}-${CXX}-${CPP_VERSION}"
    msg "Repository $REPOS with $PYTHON: Configuring..."

    SOURCE_DIR=`pwd`/$REPOS
    mkdir $BUILD_DIR
    cd $BUILD_DIR
    ln -s "$SOURCE_DIR/../libosmium"
    git clone $SOURCE_DIR $REPOS
    cd $REPOS

    msg "Repository $REPOS with $PYTHON: Building..."
    $PYTHON setup.py build

    msg "Repository $REPOS with $PYTHON: Testing..."
    cd test
    $PYTHON run_tests.py

    cd ../../..
    rm -fr $BUILD_DIR

    msg "Repository $REPOS: done\n"
    cd $CURRENT_DIR
}

cd ..

msg START

for compiler in $COMPILERS; do
    CXX=${compiler%,*}
    if [ "${CXX%-*}" = "g++" ]; then
        CC=gcc-${CXX#*-}
    fi
    if [ "${CXX%-*}" = "clang++" ]; then
        CC=clang-${CXX#*-}
    fi
    CPP_VERSION=${compiler#*,}
    msg "Building C++ stuff using compiler CXX=$CXX and CC=$CC and version $CPP_VERSION..."

    test_using_cmake libosmium
    test_using_cmake osmium-tool
    test_using_cmake osmium-contrib
    test_using_cmake osmcoastline
    test_using_cmake osm-gis-export
    test_using_cmake osm-area-tools
#    test_using_make node-osmium
done

msg "Building PyOsmium using system compiler..."
unset CC
unset CXX
unset CFLAGS
unset CXXFLAGS
test_python pyosmium python3

msg DONE

