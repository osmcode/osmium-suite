
# Notes for making releases for the Osmium suite

Some notes for the maintainer on what to do for releases.


## Preparations

* [ ] Github actions and Appveyor builds okay? (http://osmcode.org/status.html)
* [ ] Run `release_checks.sh` and check for errors.
* [ ] Run `run_tests.sh` and check for errors.


## Libosmium

* [ ] Decide on new version number (see http://semver.org/).
* [ ] Update version number in `CMakeLists.txt` (look for `LIBOSMIUM_VERSION_`)
      and `include/osmium/version.hpp`.
* [ ] Update `CHANGELOG.md`.
* [ ] Commit updates:

    git commit -m 'Release vX.Y.Z' CHANGELOG.md CMakeLists.txt include/osmium/version.hpp

* [ ] Tag release:

    git tag vX.Y.Z

* [ ] Push changes:

    git push && git push --tags

* [ ] Go to https://github.com/osmcode/libosmium/tags and create release from tag.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## PyOsmium

* [ ] Make sure tests pass: `python3 -m pytest tests`
* [ ] Decide on new version number.
* [ ] Update all version numbers in `src/osmium/version.py`.
* [ ] Update all versions in `.github/workflows/build_wheels.yml`
* [ ] Update `CHANGELOG.md`.
* [ ] Commit updates:

    git commit -m 'Release vX.Y.Z' CHANGELOG.md src/osmium/version.py .github/workflows/build_wheels.yml

* [ ] Tag release:

    git tag vX.Y.Z

* [ ] Push changes:

    git push && git push --tags

* [ ] Build Pypi package:

    rm -rf dist/ && python3 -m build -s
    
* [ ] Download all wheels from https://github.com/osmcode/pyosmium/actions into `dist` directory

* [ ] Upload packages to Pypi:

    twine upload dist/*

* [ ] Go to https://github.com/osmcode/pyosmium/releases and edit the release.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## Osmium tool

* [ ] Run IO tests. See `test/io/Makefile.in` for instructions.
* [ ] Compile with option WITH_EXTRA_TESTS and run tests.
* [ ] If needed, update libosmium version in `README.md` and `CMakeLists.txt`.
* [ ] Decide on new version number (see http://semver.org/).
* [ ] Update version number in `CMakeLists.txt` (look for `project`).
* [ ] Update `CHANGELOG.md`.
* [ ] Commit updates:

    git commit -m 'Release vX.Y.Z' CHANGELOG.md CMakeLists.txt

* [ ] Tag release:

    git tag vX.Y.Z

* [ ] Push changes:

    git push && git push --tags

* [ ] Go to https://github.com/osmcode/osmium-tool/tags and create release from tag.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## OSMCoastline

* [ ] Decide on new version number (see http://semver.org/).
* [ ] Update version number in `CMakeLists.txt` (see project()).
* [ ] Update `CHANGELOG.md`.
* [ ] Commit updates:

    git commit -m 'Release vX.Y.Z' CHANGELOG.md CMakeLists.txt

* [ ] Tag release:

    git tag vX.Y.Z

* [ ] Push changes:

    git push && git push --tags

* [ ] Go to https://github.com/osmcode/osmcoastline/releases and edit the release.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.


## Node-Osmium

* [ ] Decide on new version number (see http://semver.org/)
* [ ] Update version number in `package.json` (look for `version`)
* [ ] Update `CHANGELOG.md`
* [ ] Possibly update libosmium version number in `package.json`
* [ ] Commit updates

    git commit -m '[publish binary] Release vX.Y.Z' CHANGELOG.md package.json

* [ ] Tag release

    git tag vX.Y.Z

* [ ] Push changes

    git push && git push --tags

* [ ] Go to https://github.com/osmcode/node-osmium/releases and edit the release.
      Put "Version X.Y.Z" in the title. Cut and paste section from change log.

* [ ] Publish npm

    npm publish


## Update documentation

In `docs.osmcode.org` directory:

* [ ] Update `bin/build-docs-*`: Add new version numbers
* [ ] Run `bin/build-docs`
* [ ] Run `bin/update-links`
* [ ] Run `bin/rsync-it`


