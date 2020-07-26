import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_flutter_todo/_shared/const/DataKeys.dart';
import 'package:wire_flutter_todo/_shared/const/FilterValues.dart';

import 'base/DomElementView.dart';

class TodoFilterView extends DomElement {
  TodoFilterView(UListElement dom):super(dom) {
    Wire.data(DataKeys.FILTER).subscribe((value) {
      var filter = value as FilterValues;
      var selectedChildIndex;
      switch (filter) {
        case FilterValues.ALL: selectedChildIndex = 0; break;
        case FilterValues.ACTIVE: selectedChildIndex = 1; break;
        case FilterValues.COMPLETED: selectedChildIndex = 2; break;
      }
      (dom.querySelector('.selected') as AnchorElement).className = '';
      (dom.children[selectedChildIndex].children[0] as AnchorElement)
          .className = 'selected';
    });
  }
}

