if [ -e "./web" ]; then rm -rf "./web"; fi
echo "> Flutter web -> assets folder removed"
mkdir "./web"
cp -r assets/flutter_web/* web/
echo "> Flutter web -> web assets for Flutter copied to web folder"
flutter run -d chrome -t lib/main_flutter_web.dart
