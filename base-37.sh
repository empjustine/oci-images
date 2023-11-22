#!/bin/sh

set -xe

_name='base-37'

_machine="$(uname -m)"
_long_image_name="ghcr.io/empjustine/${_name}:${_machine}-$(date --iso=date)"
_short_image_name="ghcr.io/empjustine/${_name}:${_machine}"
_containerfile="${_name}.Containerfile"

case "$_machine" in
	"x86_64")
		_arch='amd64'
		;;
	"aarch64")
		_arch='arm64'
		;;
	*)
		echo "${_machine} unsupported"
		exit 1
		;;
esac

podman image build --pull=always --no-cache --arch "$_arch" --file "$_containerfile" --tag "$_long_image_name" \
	--label 'org.opencontainers.image.source=https://github.com/empjustine/oci-images' \
	--label "org.opencontainers.artifact.created=$(date --iso=seconds)" .
podman image tag "$_long_image_name" "$_short_image_name"

if podman login --get-login ghcr.io; then
	echo 'already logged in container registry!'
else
	bw get password ghcr.io | podman login ghcr.io -u 'empjustine' --password-stdin
fi
podman image push "$_long_image_name"
podman image push "$_short_image_name"
