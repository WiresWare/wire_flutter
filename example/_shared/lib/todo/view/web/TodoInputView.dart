import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import 'package:wire_example_shared/todo/data/dto/InputDTO.dart';
import 'base/DomElementView.dart';

class TodoInputView extends DomElement {
  TodoInputView(InputElement dom) : super(dom) {
    Wire.add(this, ViewSignals.CLEAR_INPUT, (data, wid) async => dom.value = '');
    dom
      ..text = ''
      ..onKeyPress.listen((e) async =>
        e.keyCode == KeyCode.ENTER &&
          await Wire.send(
            ViewSignals.INPUT,
            payload: InputDTO(dom.value!, '')
          ));
  }
}
