import 'dart:js_interop';
import 'package:web/web.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/data/dto/input_dto.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';
import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class TodoInputView extends DomElement {
  TodoInputView(super.dom) {
    Wire.add(this, ViewSignals.CLEAR_INPUT, _clearInput);
    print('> TodoInputView -> setup');
    dom
      ..textContent = ''
      ..addEventListener(
        'keyup',
        (KeyboardEvent e) {
          print('> TodoInputView -> keyup: ${e}');
          if (e.keyCode == KeyCode.ENTER) {
            _onInputEnter();
          }
        }.toJS,
      );
  }

  HTMLInputElement get input => dom as HTMLInputElement;

  Future<void> _clearInput(_, int __) async {
    input.value = '';
  }

  void _onInputEnter() {
    final dto = InputDTO(input.value, '');
    Wire.send(ViewSignals.INPUT, payload: dto).then((WireSendResults results) {
      print('> TodoInputView -> send results: ${results.list}');
      if (results.list.isEmpty) return;
      final result = results.list.singleWhere((item) => item is TodoVO) as TodoVO?;
      if (result != null) print('> \tresult: ${result.text} - created');
    });
  }
}
