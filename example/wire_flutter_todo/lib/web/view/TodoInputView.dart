import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_flutter_todo/_shared/const/ViewSignals.dart';
import 'package:wire_flutter_todo/_shared/data/dto/CreateDTO.dart';
import 'base/DomElementView.dart';

class TodoInputView extends DomElement {
  TodoInputView(InputElement dom):super(dom) {
    Wire.add(this, ViewSignals.CLEAR_INPUT, (data, wid) => dom.value = '');
    dom
      ..text = ''
      ..onKeyPress.listen((e) =>
        e.keyCode == KeyCode.ENTER &&
          Wire.send(ViewSignals.INPUT, CreateDTO(dom.value, '')));
  }
}

