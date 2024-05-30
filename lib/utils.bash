#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/Ph0enixKM/Amber"
TOOL_NAME="amber"
TOOL_TEST="amber -version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if amber is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed -E 's/^v([0-9]+\.[0-9]+\.[0-9]+).*$/\1/'
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if amber has other means of determining installable versions.
	list_github_tags
}

get_arch() {
	arch=$(uname | tr '[:upper:]' '[:lower:]')
	if [ "$arch" = "darwin" ]; then
		echo "macos"
	else
		echo "$arch"
	fi
}

get_cpu() {
	local machine_hardware_name
	machine_hardware_name=${ASDF_KUBECTL_OVERWRITE_ARCH:-"$(uname -m)"}

	case "$machine_hardware_name" in
	'x86_64') local cpu_type="x86_64" ;;
	'powerpc64le' | 'ppc64le') local cpu_type="ppc64le" ;;
	'aarch64') local cpu_type="arm64" ;;
	'armv7l') local cpu_type="arm" ;;
	*) local cpu_type="$machine_hardware_name" ;;
	esac

	echo "$cpu_type"
}

download_release() {
	local version filename url
	local platform
	platform="$(get_arch)"
	local cpu
	cpu=$(get_cpu)
	version="$1"
	filename="$2"

	# As the project is in alpha when asking for latest we get the newest tag, as Github doesn't have releases as yet.
	if [ "$version" == "latest" ]; then
		version=$(list_all_versions | sort_versions | tail -n 1)
	fi

	# TODO: Adapt the release URL convention for amber
	url="$GH_REPO/releases/download/${version}/amber_${platform}_${cpu}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert amber executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		# rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
