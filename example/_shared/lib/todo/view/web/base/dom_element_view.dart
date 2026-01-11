import 'package:web/web.dart';

class DomElement {
  DomElement(this._dom);
  final HTMLElement _dom;
  HTMLElement get dom => _dom;
}
