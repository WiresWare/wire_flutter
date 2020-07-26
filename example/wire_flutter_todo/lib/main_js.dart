import 'package:js/js.dart';

import 'package:wire/wire.dart';

import 'package:wire_flutter_todo/_shared/middleware/TodoMiddleware.dart';
import 'package:wire_flutter_todo/_shared/service/WebDatabaseService.dart';

import '_shared/model/TodoModel.dart';
import '_shared/controller/TodoController.dart';

var todoModel;
var todoController;

@JS('wire_data')
external set _wire_data(void Function(String dataKey, [dynamic value]) f);
@JS('wire_send')
external set _wire_send(void Function(String signal, [dynamic data]) f);

void main() {
  /* Work in progress */
  _wire_send = allowInterop(Wire.send);
  _wire_data = allowInterop(Wire.data);
  Wire.middleware(TodoMiddleware());
  var todoModel = TodoModel(WebDatabaseService(), isFlutter: false);
  TodoController(todoModel);
}
