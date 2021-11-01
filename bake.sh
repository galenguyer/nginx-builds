#!/usr/bin/env bash
# build, tag, and push docker images

# exit if a command fails
set -o errexit

# exit if a command in a pipeline fails
set -o pipefail

# exit if required variables aren't set
set -o nounset


# check for docker
if command -v docker 2>&1 >/dev/null; then
	echo "using docker..."
else
	echo "could not find docker, exiting"
	exit 1
fi

# if no registry is provided, tag image as "local" registry
registry="${REGISTRY:-local}"
echo "using registry $registry..."

hub_username="${HUB_USERNAME:-unset}"
echo "using docker hub username $hub_username"

# retrieve latest alpine version
alpine_lat="$(curl -sSL https://www.alpinelinux.org/downloads/ | grep -P 'Current Alpine Version' | grep -o -P '\d+\.\d+\.\d+')"
alpine="${ALPINE:-$alpine_lat}"
echo "using alpine version $alpine..."

# retreive latest nginx stable version
nginx_stable="$(curl -sSL https://nginx.org/en/download.html | grep -P '(\/download\/nginx-\d+\.\d+\.\d+\.tar\.gz)' -o | uniq | head -n2 | tail -n1 | grep -o -P '\d+\.\d+\.\d+')"
echo "using nginx stable version $nginx_stable..."

# retrieve latest nginx mainline version
nginx_mainline="$(curl -sSL https://nginx.org/en/download.html | grep -P '(\/download\/nginx-\d+\.\d+\.\d+\.tar\.gz)' -o | uniq | head -n1 | grep -o -P '\d+\.\d+\.\d+')"
echo "using nginx mainline version $nginx_mainline..."

# pass core count into container for build process
core_count="$(nproc)"
echo "using $core_count cores..."

# create docker images
export REGISTRY="$registry"
export HUB_USERNAME="$hub_username"
export ALPINE_VER="$alpine"
export NGINX_MAINLINE="$nginx_mainline"
export NGINX_STABLE="$nginx_stable"
export CORE_COUNT="$core_count"
docker buildx bake "$@"
