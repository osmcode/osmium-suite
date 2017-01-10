
# Notes for making releases for the Osmium suite

Some notes for the maintainer on what to do for releases.


## Preparations

* [ ] Travis and Appveyor builds okay? (http://osmcode.org/status.html)
* [ ] Run `release_checks.sh` and check for errors.
* [ ] Run `run_tests.sh` and check for errors.


## Libosmium

* [ ] Decide on new version number (see http://semver.org/).
* [ ] Update version number in `CMakeLists.txt` (look for `LIBOSMIUM_VERSION_`)
      and `include/osmium/version.hpp`.
* [ ] Update version number in `package.json`
* [ ] Update `CHANGELOG.md`.
* [ ] Commit updates:

    git commit -m 'Release vX.Y.Z' CHANGELOG.md CMakeLists.txt include/osmium/version.hpp

* [ ] Tag release:

    git tag vX.Y.Z

* [ ] Push changes:

    git push
    git push --tags

* [ ] Test npm packaging

Ensure the below command only displays files you intend to publish:

    npm pack && tar -ztvf *tgz

* [ ] Publish npm

    npm publish

* [ ] Go to https://github.com/osmcode/libosmium/releases and edit the release.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## PyOsmium

* [ ] Make sure tests pass: `cd test; python run_tests.py`
* [ ] Decide on new version number (usually same version number as Libosmium).
* [ ] Update all version numbers in `osmium/version.py`.
* [ ] Update `CHANGELOG.md`.
* [ ] Commit updates:

    git commit -m 'Release vX.Y.Z' CHANGELOG.md osmium/version.py

* [ ] Tag release:

    git tag vX.Y.Z

* [ ] Push changes:

    git push
    git push --tags

* [ ] Build Pypi package:

    rm -rf dist/
    python3 setup.py sdist
    twine upload dist/*

* [ ] Go to https://github.com/osmcode/pyosmium/releases and edit the release.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## Osmium tool

* [ ] Run IO tests. See `test/io/Makefile.in` for instructions.
* [ ] Decide on new version number (see http://semver.org/).
* [ ] Update version number in `CMakeLists.txt` (look for `OSMIUM_VERSION_`).
* [ ] Update `CHANGELOG.md`.
* [ ] Commit updates:

    git commit -m 'Release vX.Y.Z' CHANGELOG.md CMakeLists.txt

* [ ] Tag release:

    git tag vX.Y.Z

* [ ] Push changes:

    git push
    git push --tags

* [ ] Go to https://github.com/osmcode/osmium-tool/releases and edit the release.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## OSMCoastline

* [ ] Decide on new version number (see http://semver.org/).
* [ ] Update version number in `CMakeLists.txt` (look for `OSMCOASTLINE_VERSION_`).
* [ ] Update `CHANGELOG.md`.
* [ ] Commit updates:

    git commit -m 'Release vX.Y.Z' CHANGELOG.md CMakeLists.txt

* [ ] Tag release:

    git tag vX.Y.Z

* [ ] Push changes:

    git push
    git push --tags

* [ ] Go to https://github.com/osmcode/osmcoastline/releases and edit the release.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## Node-Osmium

* [ ] Decide on new version number (see http://semver.org/)
* [ ] Update version number in `package.json` (look for `version`)
* [ ] Update `CHANGELOG.md`
* [ ] Possibly update libosmium in `package.json`
* [ ] Commit updates

    git commit -m '[publish binary] Release vX.Y.Z' CHANGELOG.md package.json

* [ ] Tag release

    git tag vX.Y.Z

* [ ] Push changes

    git push
    git push --tags

* [ ] Test npm packaging

Ensure the below command only displays files you intend to publish:

    npm pack && tar -ztvf *tgz
    
* [ ] Publish npm

    npm publish

* [ ] Go to https://github.com/osmcode/node-osmium/releases and edit the release.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## Update documentation

In `docs.osmcode.org` directory:

* [ ] Update `bin/build-docs-*`: Add new version numbers
* [ ] Run `bin/build-docs`
* [ ] Run `bin/update-links`
* [ ] Run `bin/rsync-it`


