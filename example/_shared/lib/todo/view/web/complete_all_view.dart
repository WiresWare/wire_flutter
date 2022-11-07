import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';

import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class CompleteAllView extends DomElement {
  CompleteAllView(CheckboxInputElement dom) : super(dom) {
    Wire.add(this, ViewSignals.COMPLETE_ALL_FORCED, _onWireSignalForced);
    dom.checked = Wire.data(DataKeys.COMPLETE_ALL).value as bool;
    dom.onChange.listen(_onChecked);
  }

  void _onChecked (e) {
    final isChecked = (dom as CheckboxInputElement).checked;
    Wire.send(ViewSignals.COMPLETE_ALL, payload: isChecked);
  }

  Future<void> _onWireSignalForced(dynamic data, wid) async {
    print('> CompleteAllView -> onWireSignalForced: checked = $data');
    (dom as CheckboxInputElement).checked = data as bool;
  }
}
