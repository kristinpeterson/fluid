#! /bin/bash

# Default Variables
WIKI_PATH=

show_help() {
cat << EOF
  Usage: ${0##*/} [-h] [-p PATH]

  Builds the Tiddlywiki at PATH

EOF
}

while getopts hp: opt; do
	case ${opt} in
		h)
			show_help
			exit 0
			;;
		p)
			WIKI_PATH=$OPTARG
			;;
		*)
			show_help >&2
			exit 1
			;;
	esac
done

if [[ ! -z WIKI_PATH ]] && type tiddlywiki &> /dev/null ; then
	echo "Building Wiki at ${WIKI_PATH}"
	tiddlywiki "./${WIKI_PATH}" --build
else
	echo "Tiddlywiki not installed or no path specified"
	exit 1
fi