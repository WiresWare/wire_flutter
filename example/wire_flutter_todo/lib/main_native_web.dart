// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/controller/RouteController.dart';
import 'package:wire_example_shared/todo/controller/TodoController.dart';
import 'package:wire_example_shared/todo/middleware/TodoMiddleware.dart';
import 'package:wire_example_shared/todo/model/TodoModel.dart';
import 'package:wire_example_shared/todo/service/WebDatabaseService.dart';
import 'package:wire_flutter_todo/web/app.dart';

var todoModel;
var todoController;

Future<void> main() async {
  Wire.middleware(TodoMiddleware());

  final databaseService = WebDatabaseService();
  final todoModel = TodoModel(databaseService);
  if (await todoModel.whenReady) {
    TodoController(todoModel);
    RouteController();
    TodoAppWeb();
  } else {
    print('> Main -> main: todoModel.whenReady = false');
    document.querySelector('#todoapp')
      ?..innerHtml = '<h2>Error during model initialization</h2>'
      ..style.textAlign = 'center'
      ..style.padding = '2rem 0';
  }
  document.querySelector('#loading')?.remove();
}
