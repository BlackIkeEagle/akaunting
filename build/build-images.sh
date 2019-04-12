#!/usr/bin/env sh

set -e

if [[ -z $1 ]]; then
    echo "give the version to build"; exit 1;
fi
version=$1

cd "$(dirname "$(readlink -f $0)")"

[ -d application ] && rm -rf application

git clone git@github.com:BlackIkeEagle/akaunting.git application
cd application
git checkout $version
composer install --no-dev
rm -rf .git*

cd ..
docker build --squash=true -f Dockerfile-nginx -t blackikeeagle/akaunting-nginx:latest .
docker build --squash=true -f Dockerfile-php -t blackikeeagle/akaunting-php:latest .

docker push blackikeeagle/akaunting-nginx:latest
docker push blackikeeagle/akaunting-php:latest

rm -rf application
