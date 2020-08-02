import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';

import 'base/DomElementView.dart';

class ClearCompletedView extends DomElement {
  ClearCompletedView(ButtonElement dom):super(dom) {
    var listWireData = Wire.data(DataKeys.LIST);
    var countWireData = Wire.data(DataKeys.COUNT);

    var updateComponentVisibility = (value) =>
      setComponentVisibilityFrom(listWireData.value, countWireData.value);

    listWireData.subscribe(updateComponentVisibility);
    countWireData.subscribe(updateComponentVisibility);
    updateComponentVisibility(null);

    dom.onClick.listen((e) => Wire.send(ViewSignals.CLEAR_COMPLETED));
  }

  void setComponentVisibilityFrom(List list, int count) {
    print('> ClearCompletedView -> setComponentVisibilityFrom: ${list.length} - ${count}');
    dom.style.display = (count >= list?.length) ? 'none' : 'block';
  }
}

