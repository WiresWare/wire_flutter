import 'package:flutter/material.dart';
import 'package:wire/wire.dart';

import 'package:wire_example_shared/todo/service/MobileDatabaseService.dart';
import 'package:wire_flutter_todo/flutter/app.dart';

import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'package:wire_example_shared/todo/const/ApplicationState.dart';
import 'package:wire_example_shared/todo/controller/TodoController.dart';
import 'package:wire_example_shared/todo/model/TodoModel.dart';
import 'package:wire_example_shared/todo/service/IDatabaseService.dart';

var todoModel;
var todoController;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Wire.data(DataKeys.STATE, TodoApplicationState.LOADING);
  // This is a only difference from WEB
  IDatabaseService databaseService = MobileDatabaseService();
  await databaseService.init(TodoModel.LOCAL_STORAGE_KEY);

  todoModel = TodoModel(databaseService);
  todoController = TodoController(todoModel);

  runApp(TodoAppFlutter());

  Wire.data(DataKeys.STATE, TodoApplicationState.READY);
}
