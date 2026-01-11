import 'package:web/web.dart';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';

import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class CompleteAllView extends DomElement {
  CompleteAllView(HTMLInputElement dom) : super(dom) {
    Wire.add(this, ViewSignals.COMPLETE_ALL_FORCED, _onWireSignalForced);
    dom.checked = Wire.data(DataKeys.COMPLETE_ALL).value as bool;
    dom.onChange.listen(_onChecked);
  }

  void _onChecked(Event e) {
    final isChecked = (dom as HTMLInputElement).checked;
    Wire.send(ViewSignals.COMPLETE_ALL, payload: isChecked);
  }

  Future<void> _onWireSignalForced(dynamic data, wid) async {
    print('> CompleteAllView -> onWireSignalForced: checked = $data');
    (dom as HTMLInputElement).checked = data as bool;
  }
}
