import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/FilterValues.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';

class RouteController {
  RouteController() {
    window.onHashChange.listen((e) {
      checkFilterRouterChanged();
    });
    checkFilterRouterChanged();
  }

  void checkFilterRouterChanged() {
    var filter;
    switch (window.location.hash) {
      case '#/':
        filter = FilterValues.ALL;
        break;
      case '#/active':
        filter = FilterValues.ACTIVE;
        break;
      case '#/completed':
        filter = FilterValues.COMPLETED;
        break;
    }
    if (filter != null) Wire.send(ViewSignals.FILTER, payload: filter);
  }
}
