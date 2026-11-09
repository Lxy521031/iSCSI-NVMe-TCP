#!/bin/bash
# Build-only artifact: intentionally performs no installation or registration.
set -euo pipefail
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="${1:-$repo_dir/dist}"
mkdir -p "$output_dir"
output_dir="$(cd "$output_dir" && pwd)"
cd "$repo_dir"
xcodebuild -project apps/iSCSIInitiator.xcodeproj \
  -scheme 'iSCSI Initiator' -configuration Release \
  -derivedDataPath "$repo_dir/build/localized" CODE_SIGNING_ALLOWED=NO build
app_path="$repo_dir/build/localized/Build/Products/Release/iSCSI Initiator.app"
version="$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' "$app_path/Contents/Info.plist")"
staging_dir="$(mktemp -d "${TMPDIR:-/tmp}/iscsi-chinese.XXXXXX")"
trap 'rm -rf "$staging_dir"' EXIT
/usr/bin/ditto "$app_path" "$staging_dir/iSCSI Initiator.app"
cp README.zh-CN.md "$staging_dir/请先阅读-未签名构建.md"
cp LICENSE "$staging_dir/LICENSE"
archive_path="$output_dir/iSCSI-Initiator-$version-zh-Hans-unsigned.zip"
/usr/bin/ditto -c -k --sequesterRsrc "$staging_dir" "$archive_path"
/usr/bin/shasum -a 256 "$archive_path" > "$archive_path.sha256"
printf '\n未签名构建产物（不可直接替换应用）：%s\n' "$archive_path"
