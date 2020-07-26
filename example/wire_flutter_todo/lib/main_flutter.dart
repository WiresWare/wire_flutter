import 'package:flutter/material.dart';
import 'package:wire/wire.dart';

import 'package:wire_flutter_todo/_shared/service/MobileDatabaseService.dart';
import 'package:wire_flutter_todo/flutter/app.dart';

import '_shared/const/DataKeys.dart';
import '_shared/const/ApplicationState.dart';
import '_shared/controller/TodoController.dart';
import '_shared/model/TodoModel.dart';
import '_shared/service/IDatabaseService.dart';

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
