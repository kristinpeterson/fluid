#! /bin/bash

# Default Variables
GH_USER="Travis"
GH_EMAIL=${GH_EMAIL}
GH_URI=${GH_URI}
GH_TOKEN=${GH_TOKEN}

BUILD_PATH=

show_help() {
cat << EOF
  Usage: ${0##*/} [-h] [-p PATH]

  Deploys Files at ./PATH/output to GitHub Pages
EOF
}

while getopts hp: opt; do
	case ${opt} in
		h)
			show_help
			exit 0
			;;
		p)
			BUILD_PATH="./${OPTARG}/output"
			;;
		*)
			show_help >&2
			exit 1
			;;
	esac
done

if [[ ! -d ./$BUILD_PATH ]]; then
	echo "Path [ ${BUILD_PATH} ] does not exist or is not a directory" && exit 1
fi

if [[ ! -z ./${GH_EMAIL} ]] && [[ ! -z ${GH_URI} ]] && [[ ! -z ${GH_TOKEN} ]]; then
	echo "Deploying ${BUILD_PATH} to ${GH_URI}" 
	cd $BUILD_PATH

	echo "Initializing gh-pages Repository"
	git init
	git config user.name "${GH_USER}"
	git config user.email "${GH_EMAIL}"
	git add .
	git commit -m "Deployed to GitHub Pages On $(date)"

	echo "Pushing to ${GH_URI}"
	git push --force --quiet "https://${GH_TOKEN}@${GH_URI}" master:gh-pages > /dev/null 2>&1
else 
	echo "Configuration Error... GH_EMAIL, GH_URI and GH_TOKEN must be defined in the build" && exit 1
fi