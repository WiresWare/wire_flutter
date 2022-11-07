import 'dart:html';

class DomElement {
  DomElement(this._dom);
  final Element _dom;
  Element get dom => _dom;
}
