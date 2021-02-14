import 'dart:convert';

import 'package:js/js.dart';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'package:wire_example_shared/todo/const/FilterValues.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';

import 'package:wire_example_shared/todo/middleware/TodoMiddleware.dart';
import 'package:wire_example_shared/todo/service/WebDatabaseService.dart';
import 'package:wire_example_shared/todo/model/TodoModel.dart';
import 'package:wire_example_shared/todo/controller/TodoController.dart';

@JS('wire_data')
external set _wire_data(void Function(String key, { dynamic value }) f);
@JS('wire_send')
external set _wire_send(void Function(String signal, {dynamic payload, Object scope}) f);
@JS('wire_add')
external set _wire_add(void Function(Object scope, String signal, WireListener listener, {int replies}) f);
@JS('ViewSignals')
external set _ViewSignals(String Function() f);
@JS('FilterValues')
external set _FilterValues(String Function() f);
@JS('DataKeys')
external set _DataKeys(String Function() f);

final jsonEncoder = JsonEncoder();
String mDK = jsonEncoder.convert({
  'LIST': DataKeys.LIST,
  'COUNT': DataKeys.COUNT,
  'FILTER': DataKeys.FILTER,
  'STATE': DataKeys.STATE,
});

String mFV = jsonEncoder.convert({
  'ALL': FilterValues.ALL,
  'ACTIVE': FilterValues.ACTIVE,
  'COMPLETED': FilterValues.COMPLETED,
});

String mVS = jsonEncoder.convert({
  'INPUT': ViewSignals.INPUT,
  'EDIT': ViewSignals.EDIT,
  'DELETE': ViewSignals.DELETE,
  'DISMISSED': ViewSignals.DISMISSED,
  'TOGGLE': ViewSignals.TOGGLE,
  'FILTER': ViewSignals.FILTER,
  'CLEAR_INPUT': ViewSignals.CLEAR_INPUT,
  'CLEAR_COMPLETED': ViewSignals.CLEAR_COMPLETED,
  'COMPLETE_ALL': ViewSignals.COMPLETE_ALL
});


void main() {

  _DataKeys = allowInterop(() => mDK);
  _FilterValues = allowInterop(() => mFV);
  _ViewSignals = allowInterop(() => mVS);

  _wire_add = allowInterop(Wire.add);
  _wire_send = allowInterop(Wire.send);
  _wire_data = allowInterop(Wire.data);

  Wire.middleware(TodoMiddleware());
  TodoController(
    TodoModel(WebDatabaseService(), isFlutter: false)
  );
}
