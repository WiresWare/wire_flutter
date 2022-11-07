// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/controller/route_controller.dart';
import 'package:wire_example_shared/todo/controller/todo_controller.dart';
import 'package:wire_example_shared/todo/middleware/todo_middleware.dart';
import 'package:wire_example_shared/todo/model/todo_model.dart';
import 'package:wire_example_shared/todo/service/web_database_service.dart';
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
