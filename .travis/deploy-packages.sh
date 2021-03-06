#! /bin/bash

set -e

# Only deploy if building from master on my repo.
if [ "${TRAVIS_REPO_SLUG}" != "jasonish/evebox" ]; then
    echo "Not deploying packages for builds from repo ${TRAVIS_REPO_SLUG}."
    exit 0
fi

if [ "${TRAVIS_BRANCH}" != "master" ]; then
    echo "Not deploying packages for branch ${TRAVIS_BRANCH}."
    exit 0
fi

if [ "${BINTRAY_API_KEY}" = "" ]; then
    echo "BINTRAY_API_KEY is empty. Not deploying."
    exit 0
fi

# Deploy zip's to Bintray.
for zip in dist/evebox-*.zip; do
    echo "Uploading ${zip}."
    curl -T ${zip} -u jasonish:${BINTRAY_API_KEY} \
	 "https://api.bintray.com/content/jasonish/evebox-zip-dev/evebox/dev/$(basename ${zip})?publish=1&override=1"	 
    echo
done

# Deploy RPM to Bintray.
for rpm in dist/evebox*.rpm; do
    echo "Uploading ${rpm}."
    curl -T ${rpm} -u jasonish:${BINTRAY_API_KEY} \
	 "https://api.bintray.com/content/jasonish/evebox-rpm-dev/evebox/dev/$(basename ${rpm})?publish=1&override=1"
    echo
    break
done

# Deploy Debian package to Bintray.
for deb in dist/evebox*.deb; do
    echo "Uploading ${deb}."
    curl -T ${deb} -u jasonish:${BINTRAY_API_KEY} \
	 "https://api.bintray.com/content/jasonish/deb-evebox-latest/evebox/latest/$(basename ${deb});deb_distribution=jessie;deb_component=main;deb_architecture=amd64?publish=1&override=1"
    echo
    break
done
