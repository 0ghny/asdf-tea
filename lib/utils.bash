#!/usr/bin/env bash

set -euo pipefail

RELEASES_URL="https://dl.gitea.io/tea"
TOOL_NAME="tea"
TOOL_TEST="tea --help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
  local version
  for version in $(curl -s "${RELEASES_URL}" | grep -oP "<span class=\"name\">(.*)<\/span>" |
    grep -o "[0-9\+\.[0-9]\+\.[0-9]\+\(\(-\|+\)[a-z]\+[0-9]*\)*"); do
    echo "${version}"
  done
}

download_release() {
  local version filename url
  local -r platform="$(get_platform)"
  local -r arch="$(get_arch)"
  version="$1"
  filename="$2"

  url="$RELEASES_URL/${version}/$TOOL_NAME-$version-$platform-$arch"

  echo "* Downloading $TOOL_NAME release $version ${platform}/${arch}..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
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
    echo "Installing from $ASDF_DOWNLOAD_PATH to $install_path"
    cp -r "$ASDF_DOWNLOAD_PATH/$TOOL_NAME-$version" "$install_path/$TOOL_NAME"
    chmod +x "$install_path/$TOOL_NAME"
    test -x "$install_path/$TOOL_NAME" || fail "Expected $install_path/$TOOL_NAME binary not found."
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}

# Credits: https://github.com/asdf-community/asdf-hashicorp/blob/bc4dec6e99c501d126bf2f699190e4a0c9a10b3e/bin/install#L106
# LICENSE: MIT (https://github.com/asdf-community/asdf-hashicorp/blob/bc4dec6e99c501d126bf2f699190e4a0c9a10b3e/LICENSE#L1)
get_platform() {
  local -r kernel="$(uname -s)"
  if [[ ${OSTYPE} == "msys" || ${kernel} == "CYGWIN"* || ${kernel} == "MINGW"* ]]; then
    echo windows
  else
    uname | tr '[:upper:]' '[:lower:]'
  fi
}

get_arch() {
  local -r machine="$(uname -m)"
  local -r tool_specific_arch_override="ASDF_TEA_OVERWRITE_ARCH"

  OVERWRITE_ARCH=${!tool_specific_arch_override:-${ASDF_TEA_OVERWRITE_ARCH:-"false"}}

  if [[ ${OVERWRITE_ARCH} != "false" ]]; then
    echo "${OVERWRITE_ARCH}"
  elif [[ ${machine} == "arm64" ]] || [[ ${machine} == "aarch64" ]]; then
    echo "arm64"
  elif [[ ${machine} == *"arm"* ]] || [[ ${machine} == *"aarch"* ]]; then
    echo "arm"
  elif [[ ${machine} == *"386"* ]]; then
    echo "386"
  else
    echo "amd64"
  fi
}
