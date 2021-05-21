import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import 'package:wire_example_shared/todo/data/dto/InputDTO.dart';
import 'base/DomElementView.dart';

class TodoInputView extends DomElement {
  TodoInputView(InputElement dom) : super(dom) {
    Wire.add(this, ViewSignals.CLEAR_INPUT, _clearInput);

    dom
      ..text = ''
      ..onKeyPress.listen((e) =>
        e.keyCode == KeyCode.ENTER &&
        _sendInputSignalWithText(dom.value!));
  }

  _clearInput(value, wid) {
    (this.dom as InputElement).value = '';
  }

  _sendInputSignalWithText(text) {
    Wire.send(ViewSignals.INPUT, payload: InputDTO(text, ''));
  }
}
