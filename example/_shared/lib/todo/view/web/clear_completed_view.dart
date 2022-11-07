import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';

import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class ClearCompletedView extends DomElement {
  ClearCompletedView(ButtonElement dom) : super(dom) {
    final wireDataTodoList = Wire.data(DataKeys.LIST_OF_IDS);
    final wireDataCount = Wire.data(DataKeys.COUNT);

    Future<void> updateComponentVisibility(_) async =>
      setComponentVisibilityFrom(
        wireDataTodoList.value as List<String>,
        wireDataCount.value as int
      );

    wireDataTodoList.subscribe(updateComponentVisibility);
    wireDataCount.subscribe(updateComponentVisibility);
    updateComponentVisibility(null);

    dom.onClick.listen((e) => Wire.send(ViewSignals.CLEAR_COMPLETED));
  }

  void setComponentVisibilityFrom(List<String> list, int count) {
    print('> ClearCompletedView -> setComponentVisibilityFrom: ${list.length} - ${count}');
    dom.style.display = (count >= list.length) ? 'none' : 'block';
  }
}
