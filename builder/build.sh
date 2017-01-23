#!/bin/bash

set -e

SN="${BASH_SOURCE[0]##*/}"
SD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT=$(cd $SD && cd .. && pwd)

echo "project root path is ${ROOT}, SN is ${SN}, SD is ${SD}"


# just for check whether if the real shell folder or the folder with symbolic link
if [ ! -f "${SD}/origin.mark" ] ; then
	SD="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )"
	if [ ! -f "${SD}/config.sh.sample" ] ; then
		SD="/usr/local/kspringboot"
	fi
fi

# usage instruct user how to use the command
function usage() {
	cat << EOF
Usage: ${SN} [Options]
Options:
  -h        : usage
  -r        : build all images and startup the system
  -b        : build all existed images
  -q        : quick startup the system without build images
EOF
[ $# -gt 0 ] && { echo ; echo "$@" ; exit 1 ; }
exit 0
}

# check user
if [ "$(id -u)" -gt 0 ] ; then
	sudo="sudo"
else
	sudo=""
fi

# check docker env
if type docker &>/dev/null ; then
	docker="${sudo} docker"
elif type docker.io &>/dev/null ; then
	docker="${sudo} docker.io"
else
	echo "docker command not found"
	exit 1
fi

type getopt cat wget >/dev/null

opt="$(getopt -o rbq -- "$@")" || usage "Parse options failed"
eval set -- "${opt}"

FLAG_BUILD_AND_START="0"
FLAG_BUILD_ONLY="0"
FLAG_START_ONLY="0"

while true ; do
	case "${1}" in
	-h) usage ; shift ;;
	-r) FLAG_BUILD_AND_START="1" ; shift ;;
	-b) FLAG_BUILD_ONLY="1" ; shift ;;
	-q) FLAG_START_ONLY="1" ; shift ;;
	--) shift ; break ;;
	*) echo "Internal error!" ; exit 1 ;;
	esac
done

function check_copy_file() {
	local filename="${1}"
	local localfile

	[ -s "${filename}" ] && return 0

	localfile="$(find "${ROOT}" -iname "${filename}" ! -empty -print -quit)"

	if [ "${localfile}" ] ; then
		cp -aL "${localfile}" "${filename}"
	fi

	if [ -s "${filename}" ] ; then
		return 0
	else
		return 1
	fi
}
