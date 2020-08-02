import 'dart:html';

import 'package:wire/wire.dart';

import 'package:wire_flutter_todo/web/app.dart';
import 'package:wire_example_shared/todo/middleware/TodoMiddleware.dart';
import 'package:wire_example_shared/todo/model/TodoModel.dart';
import 'package:wire_example_shared/todo/service/WebDatabaseService.dart';
import 'package:wire_example_shared/todo/controller/TodoController.dart';
import 'web/controller/RouteController.dart';

var todoModel;
var todoController;

Future<void> main() async {
  Wire.middleware(TodoMiddleware());

  var todoModel = TodoModel(WebDatabaseService(), isFlutter: false);

  TodoController(todoModel);
  RouteController();

  TodoAppWeb();

  document.querySelector('#loading').remove();
}
