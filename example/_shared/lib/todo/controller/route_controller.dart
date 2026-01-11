import 'dart:js_interop';
import 'package:web/web.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';

class RouteController {
  RouteController() {
    window.addEventListener(
      'hashchange',
      (HashChangeEvent event) {
        print('> RouteController -> hashchange: ${event}');
        checkFilterRouterChanged();
      }.toJS,
    );
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
    if (filter != null) {
      print('> RouteController -> checkFilterRouterChanged - filter: $filter');
      Wire.send(ViewSignals.FILTER, payload: filter);
    }
  }
}
