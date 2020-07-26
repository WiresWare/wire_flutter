[[ -d web ]] && rm -r web/
echo "Assets folder removed"
cp -r assets/flutter_web/ web/
echo "Web assets for Flutter copied to web folder"
flutter run -d chrome -t lib/main_flutter_web.dart
