#!/bin/sh

set -xe

_ghcr_user='empjustine'
_name='base-37'
_github_repository='https://github.com/empjustine/oci-images'

_machine="$(uname -m)"
_long_image_name="ghcr.io/${_ghcr_user}/${_name}:${_machine}-$(date --iso=date)"
_short_image_name="ghcr.io/${_ghcr_user}/${_name}:${_machine}"
_containerfile="${_name}.Containerfile"
_repository_label="org.opencontainers.image.source=${_github_repository}"
_created_label="org.opencontainers.artifact.created=$(date --iso=seconds)"

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

podman image build --pull=always --no-cache --arch "$_arch" --file "$_containerfile" --tag "$_long_image_name" --label "$_repository_label" --label "$_created_label" .
podman image tag "$_long_image_name" "$_short_image_name"

if podman image push "$_long_image_name"; then
	echo 'already logged in container registry!'
else
	bw get password ghcr.io | podman login ghcr.io -u "$_ghcr_user" --password-stdin
	podman image push "$_long_image_name"
fi
podman image push "$_short_image_name"
