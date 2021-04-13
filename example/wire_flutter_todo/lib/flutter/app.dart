// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wire_flutter_todo/flutter/const/Routes.dart';
import 'package:wire_flutter_todo/flutter/view/screens/add_edit_screen.dart';
import 'package:wire_flutter_todo/flutter/view/screens/home_screen.dart';

class TodoAppFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: UniqueKey(),
      onGenerateTitle: (context) => 'Todo Wire Application',
      theme: ArchSampleTheme.theme,
      localizationsDelegates: [],
      home: HomeScreen(),
      routes: {
        TodoRoutes.home: (context) => HomeScreen(),
        TodoRoutes.addTodo: (context) => AddEditScreen(),
      },
    );
  }
}

class ArchSampleTheme {
  static ThemeData get theme {
    final themeData = ThemeData.dark();
    final textTheme = themeData.textTheme;
    final body1 = textTheme.bodyText1.copyWith(decorationColor: Colors.transparent);

    return ThemeData.dark().copyWith(
      primaryColor: Colors.grey[800],
      accentColor: Colors.cyan[300],
      buttonColor: Colors.grey[800],
      textSelectionColor: Colors.cyan[100],
      toggleableActiveColor: Colors.cyan[300],
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.cyan[300],
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: themeData.dialogBackgroundColor,
        contentTextStyle: body1,
        actionTextColor: Colors.cyan[300],
      ),
      textTheme: textTheme.copyWith(
        bodyText1: body1,
      ),
    );
  }
}
