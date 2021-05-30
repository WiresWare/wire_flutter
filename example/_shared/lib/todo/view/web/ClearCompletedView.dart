import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';

import 'base/DomElementView.dart';

class ClearCompletedView extends DomElement {
  ClearCompletedView(ButtonElement dom) : super(dom) {
    final wireDataTodoList = Wire.data(DataKeys.LIST_OF_IDS);
    final wireDataCount = Wire.data(DataKeys.COUNT);

    final updateComponentVisibility = (value) async =>
      setComponentVisibilityFrom(
        wireDataTodoList.value,
        wireDataCount.value
      );

    wireDataTodoList.subscribe(updateComponentVisibility);
    wireDataCount.subscribe(updateComponentVisibility);
    updateComponentVisibility(null);

    dom.onClick.listen((e) => Wire.send(ViewSignals.CLEAR_COMPLETED));
  }

  void setComponentVisibilityFrom(List list, int count) {
    print(
        '> ClearCompletedView -> setComponentVisibilityFrom: ${list.length} - ${count}');
    dom.style.display = (count >= list.length) ? 'none' : 'block';
  }
}
