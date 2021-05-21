import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';

import 'base/DomElementView.dart';

class CompleteAllView extends DomElement {
  CompleteAllView(CheckboxInputElement dom) : super(dom) {
    dom.onChange.listen(_onCompleteAllToggle);
  }

  void _onCompleteAllToggle(e) {
    final isToggled = (this.dom as CheckboxInputElement).checked;
    Wire.send(ViewSignals.COMPLETE_ALL, payload: isToggled);
  }
}
