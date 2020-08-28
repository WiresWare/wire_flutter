import 'package:js/js.dart';

import 'package:wire/wire.dart';

import 'package:wire_example_shared/todo/middleware/TodoMiddleware.dart';
import 'package:wire_example_shared/todo/service/WebDatabaseService.dart';
import 'package:wire_example_shared/todo/model/TodoModel.dart';
import 'package:wire_example_shared/todo/controller/TodoController.dart';

var todoModel;
var todoController;

@JS('wire_data')
external set _wire_data(void Function(String dataKey, [dynamic value]) f);
@JS('wire_send')
external set _wire_send(void Function(String signal, {dynamic payload, Object scope}) f);

void main() {
  /* Work in progress */
  _wire_send = allowInterop(Wire.send);
  _wire_data = allowInterop(Wire.data);

  Wire.middleware(TodoMiddleware());
  TodoController(TodoModel(WebDatabaseService(), isFlutter: false));
}
