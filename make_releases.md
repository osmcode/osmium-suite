
# Notes for making releases for the osmium suite

Some notes for the maintainer on what to do for releases.


## Preparations

* [ ] Travis and Appveyor builds okay? (http://osmcode.org/status.html)
* [ ] Run `release_checks.sh` and check for errors
* [ ] Run `run_tests.sh` and check for errors


## Libosmium

* [ ] Decide on new version number (see http://semver.org/)
* [ ] Update version number in `CMakeLists.txt` (look for `LIBOSMIUM_VERSION_`)
* [ ] Update `CHANGELOG.md`
* [ ] Commit updates

    git commit -m 'Release vX.Y.Z' CHANGELOG.md CMakeLists.txt

* [ ] Tag release

    git tag vX.Y.Z

* [ ] Push changes

    git push
    git push --tags


## PyOsmium

* [ ] Decide on new version number (usually same version number as Libosmium)
* [ ] Update version number in `setup.py`. Look for `version`.
* [ ] Update version number in `doc/conf.py`. Look for `version` and `release`.
* [ ] Update `CHANGELOG.md`
* [ ] Commit updates

    git commit -m 'Release vX.Y.Z' CHANGELOG.md setup.py doc/conf.py

* [ ] Tag release `git tag vX.Y.Z`

    git tag vX.Y.Z

* [ ] Push changes

    git push
    git push --tags


## Osmium tool

* [ ] Decide on new version number (see http://semver.org/)
* [ ] Update version number in `CMakeLists.txt` (look for `OSMIUM_VERSION_`)
* [ ] Update `CHANGELOG.md`
* [ ] Commit updates

    git commit -m 'Release vX.Y.Z' CHANGELOG.md CMakeLists.txt

* [ ] Tag release

    git tag vX.Y.Z

* [ ] Push changes

    git push
    git push --tags


## Update documentation

In `docs.osmcode.org` directory:

* [ ] Update `bin/build-docs-*`: Add new version numbers
* [ ] Run `bin/build-docs`
* [ ] Run `bin/update_links`
* [ ] Run `bin/rsync-it`


