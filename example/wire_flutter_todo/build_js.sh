[[ -d web ]] && rm -r web/
echo "Assets folder removed"
cp -r assets/react/ web/
echo "Web assets for Flutter copied to web folder"
dart2js -o web/js/shared.js lib/main_js.dart

