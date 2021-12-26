import 'package:flutter/material.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ApplicationState.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'package:wire_example_shared/todo/controller/TodoController.dart';
import 'package:wire_example_shared/todo/model/TodoModel.dart';
import 'package:wire_example_shared/todo/service/WebDatabaseService.dart';
import 'package:wire_flutter_todo/flutter/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Wire.data(DataKeys.STATE, value: TodoApplicationState.LOADING);

  final databaseService = WebDatabaseService();
  final todoModel = TodoModel(databaseService);

  if (await todoModel.whenReady) {
    print('> Main -> main: todoModel.whenReady');
    TodoController(todoModel);
    runApp(TodoAppFlutter());
  }

  Wire.data(DataKeys.STATE, value: TodoApplicationState.READY);
}
