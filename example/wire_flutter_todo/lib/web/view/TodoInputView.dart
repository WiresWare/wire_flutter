import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import 'package:wire_example_shared/todo/data/dto/InputDTO.dart';
import 'base/DomElementView.dart';

class TodoInputView extends DomElement {
  TodoInputView(InputElement dom):super(dom) {
    Wire.add(this, ViewSignals.CLEAR_INPUT, (data, wid) => dom.value = '');
    dom
      ..text = ''
      ..onKeyPress.listen((e) =>
        e.keyCode == KeyCode.ENTER &&
          Wire.send(ViewSignals.INPUT, InputDTO(dom.value, '')));
  }
}

