#!/bin/sh
#
#  release-checks.sh
#
#  Does some consistency checks that should be run at least for each release.
#
#

REPOSITORIES="osmium-tool osmium-contrib osm-gis-export osmcoastline osm-area-tools osmium-filter osmium-surplus"
CATCH_REPOSITORIES="osmium-tool osmium-filter"
ALL_REPOSITORIES="libosmium $REPOSITORIES"

cd ..

#set -x
set -e

BOLD="\033[1m"
NORM="\033[0m"
GREEN="\033[1;32m"
DARKRED="\033[31m"
RED="\033[1;31m"

echo "== Comparing cmake files..."
for repos in $REPOSITORIES; do
    for file in FindLZ4 FindOsmium FindProtozero; do
        if diff -u libosmium/cmake/${file}.cmake $repos/cmake/${file}.cmake; then
            echo "[${GREEN}OK ${NORM}] ${file}"
        else
            echo "[${RED}ERR${NORM}] ${file}"
        fi
    done
done
echo "== Done."

echo "== Comparing catch files..."
for repos in $CATCH_REPOSITORIES; do
    if diff -u libosmium/test/catch/catch.hpp $repos/test/include/catch.hpp; then
        echo "[${GREEN}OK ${NORM}] test/catch/catch.hpp"
    else
        echo "[${RED}ERR${NORM}] test/catch/catch.hpp"
    fi
done
echo "== Done."

echo "== Finding tests not run..."
cd libosmium
BUILD="build-test-check"
mkdir -p $BUILD
cd $BUILD
skipped_tests=`cmake -L .. 2>/dev/null | grep "OSMIUM_SKIPPED_TESTS" | cut -d= -f2`
if [ -n "${skipped_tests}" ]; then
    echo "Skipped tests:${skipped_tests}"
fi
cd ..
rm -fr $BUILD
cd ..
echo "== Done."

echo "== Finding left over test build directories..."
for repos in $ALL_REPOSITORIES; do
    find $repos -mindepth 1 -maxdepth 1 -type d -name build-test-\*
done
echo "== Done."

