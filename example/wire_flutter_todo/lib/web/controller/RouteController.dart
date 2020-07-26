import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_flutter_todo/_shared/const/FilterValues.dart';
import 'package:wire_flutter_todo/_shared/const/ViewSignals.dart';

class RouteController {
  RouteController() {
    window.onHashChange.listen((e) {
      checkFilterRouterChanged();
    });
    checkFilterRouterChanged();
  }

  void checkFilterRouterChanged () {
    var filter;
    switch (window.location.hash) {
      case '#/': filter = FilterValues.ALL; break;
      case '#/active': filter = FilterValues.ACTIVE; break;
      case '#/completed': filter = FilterValues.COMPLETED; break;
    }
    if (filter != null) Wire.send(ViewSignals.FILTER, filter);
  }
}
