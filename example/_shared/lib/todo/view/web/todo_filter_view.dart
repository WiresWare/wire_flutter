import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';

import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class TodoFilterView extends DomElement {
  TodoFilterView(UListElement dom) : super(dom) {
    Wire.data(DataKeys.FILTER).subscribe((filter) async {
      if (filter == null) return;
      final selectedChildIndex = _FILTER_TO_VALUE[filter]!;
      print('> TodoFilterView -> DataKeys.FILTER subscribe: ${filter} - ${selectedChildIndex}');
      (dom.querySelector('.$CLASS_NAME_SELECTED')! as HtmlElement).className = '';
      (dom.children[selectedChildIndex].children[0] as HtmlElement).className = CLASS_NAME_SELECTED;
    });
  }

  static const Map<FilterValues, int> _FILTER_TO_VALUE = {
    FilterValues.ALL: 0,
    FilterValues.ACTIVE: 1,
    FilterValues.COMPLETED: 2
  };

  final CLASS_NAME_SELECTED = 'selected';
}
