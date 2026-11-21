#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

XWIN_CACHE_PATH="${1:-.xwin-cache}"
SPLAT_PATH="${2:-splat}"

packages=(
    "$XWIN_CACHE_PATH"/dl/Microsoft.VC.*.CRT.Headers.base.vsix
)

if (( ${#packages[@]} == 0 )); then
    echo "MSVC CRT headers package not found." >&2
    exit 1
fi

for vsix in "${packages[@]}"; do
    entries="$(unzip -Z1 "$vsix")"

    while IFS= read -r entry; do
        if [[ "$entry" =~ ^Contents/VC/Tools/MSVC/([^/]+)/modules/std\.ixx$ ]]; then
            version="${BASH_REMATCH[1]}"
            prefix="Contents/VC/Tools/MSVC/$version"

            # Ensure the modules match the splatted STL headers.
            if ! cmp -s \
                "$SPLAT_PATH/crt/include/yvals_core.h" \
                <(unzip -p "$vsix" "$prefix/include/yvals_core.h"); then
                continue
            fi

            echo "VSIX: $vsix"
            echo "MSVC version: $version"

            temp_dir="$(mktemp -d)"
            trap 'rm -rf "$temp_dir"' EXIT

            unzip -oq "$vsix" "$prefix/modules/*" -d "$temp_dir"

            mkdir -p "$SPLAT_PATH/crt/modules"

            cp -a "$temp_dir/$prefix/modules/." \
                "$SPLAT_PATH/crt/modules/"

            echo "MSVC STL modules extracted successfully."
            exit 0
        fi
    done <<< "$entries"
done

echo "Matching MSVC STL modules not found." >&2
exit 1
