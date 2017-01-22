#!/bin/bash

set -euxo pipefail


SN="${BASH_SOURCE[0]##*/}"
SD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# just for check whether if the real shell folder or the folder with symbolic link
if [ ! -f "${SD}/origin.mark" ] ; then
	SD="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd )"
	if [ ! -f "${SD}/config.sh.sample" ] ; then
		SD="/usr/local/kspringboot"
	fi
fi

#init all dependencies sh
function usage() {
	cat << EOF
Usage: ${SN} [Options]
Options:
  -r        : build all images and startup the system
  -b        : build all existed images
  -q        : quick startup the system without build images
EOF
[ $# -gt 0 ] && { echo ; echo "$@" ; exit 1 ; }
exit 0
}