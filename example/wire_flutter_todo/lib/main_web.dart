import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_flutter_todo/_shared/middleware/TodoMiddleware.dart';

import 'package:wire_flutter_todo/_shared/service/WebDatabaseService.dart';
import 'package:wire_flutter_todo/web/app.dart';
import '_shared/controller/TodoController.dart';
import '_shared/model/TodoModel.dart';
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
