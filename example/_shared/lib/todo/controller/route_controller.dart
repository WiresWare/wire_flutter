import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';

class RouteController {
  RouteController() {
    window.onHashChange.listen((e) {
      checkFilterRouterChanged();
    });
    checkFilterRouterChanged();
  }

  void checkFilterRouterChanged() {
    FilterValues? filter;
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
