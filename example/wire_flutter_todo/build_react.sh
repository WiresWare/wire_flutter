#!/bin/bash
get_abs_filename() {
# $1 : relative filename
  if [ -d "$(dirname "$1")" ]; then
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
  fi
}

[[ -d web ]] && rm -r web/*
echo "Web folder removed"
rsync -av ./assets/react/ ./web/ --exclude=node_modules
FROM_NM_PATH=$(get_abs_filename "./assets/react/node_modules")
TO_NM_PATH=$(get_abs_filename "./web/node_modules")
ln -s -n "$FROM_NM_PATH" "$TO_NM_PATH"
echo "Web assets for React copied to web folder"
cp ./assets/_wrapper/wire.js ./web/src/wire.js
echo "Wire wrapper copied"
dart2js -o web/public/js/shared.js lib/main_js.dart
echo "JS versions generated"
cd ./web || return
npm run start

