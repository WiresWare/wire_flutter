import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_flutter_todo/_shared/const/ViewSignals.dart';

import 'base/DomElementView.dart';

class CompleteAllView extends DomElement {
  CompleteAllView(CheckboxInputElement dom):super(dom) {
    dom.onChange.listen((e) =>
      Wire.send(ViewSignals.COMPLETE_ALL, dom.checked));
  }
}

