import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/data/dto/input_dto.dart';
import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class TodoInputView extends DomElement {
  TodoInputView(InputElement dom) : super(dom) {
    Wire.add(this, ViewSignals.CLEAR_INPUT, (data, wid) async => dom.value = '');

    dom
      ..text = ''
      ..onKeyPress.listen((e) async =>
        e.keyCode == KeyCode.ENTER
        && (await Wire.send(ViewSignals.INPUT, payload: InputDTO(dom.value!, ''))).signalHasNoSubscribers);
  }
}
