import 'package:web/web.dart';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class ClearCompletedView extends DomElement {
  ClearCompletedView(HTMLButtonElement dom) : super(dom) {
    final wdTodoList = Wire.data(DataKeys.LIST_OF_IDS);
    final wdCount = Wire.data(DataKeys.COUNT);

    Future<void> updateComponentVisibility([_]) async {
      final todos = wdTodoList.value as List<String>;
      final count = wdCount.value as int;
      setComponentVisibilityFrom(todos, count);
    }

    wdTodoList.subscribe(updateComponentVisibility);
    wdCount.subscribe(updateComponentVisibility);

    updateComponentVisibility();

    dom.onClick.listen((e) => Wire.send(ViewSignals.CLEAR_COMPLETED));
  }

  void setComponentVisibilityFrom(List<String> list, int count) {
    print('> ClearCompletedView -> setComponentVisibilityFrom: ${list.length} - ${count}');
    dom.style.display = (count >= list.length) ? 'none' : 'block';
  }
}
