import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'base/DomElementView.dart';
import 'TodoListItemView.dart';

class TodoListView extends DomElement {
  var _renderedIds = [];
  TodoListView(UListElement dom) : super(dom) {
    var wireDataTodoList = Wire.data(DataKeys.LIST_OF_IDS);
    var todoList = (wireDataTodoList.value as List<String>);
    var append = (id) async {
      print('> TodoListView -> append id = $id');
      dom.insertBefore(TodoListItemView(id).dom, dom.firstChild);
    };
    if (todoList.isNotEmpty) todoList.forEach(append);
    _renderedIds = todoList.toList();

    wireDataTodoList.subscribe((value) async {
      final list = value as List<String>;
      list.forEach((String id) => { if (!_renderedIds.contains(id)) append(id) });
      _renderedIds = todoList.toList();
      print('> TodoListView -> wireDataTodoList.subscribe: $list');
    });
  }
}
