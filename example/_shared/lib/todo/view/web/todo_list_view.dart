import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_list_item_view.dart';

class TodoListView extends DomElement {
  TodoListView(super.dom) {
    final wireDataTodoList = Wire.data(DataKeys.LIST_OF_IDS);
    final todoList = wireDataTodoList.value as List<String>;

    if (todoList.isNotEmpty) todoList.forEach(append);
    _renderedIds = todoList.toList();

    wireDataTodoList.subscribe((list) async {
      print('> TodoListView -> wireDataTodoList.update: ${list}');
      for (final id in list as List<String>) {
        if (!_renderedIds.contains(id)) {
          append(id);
        }
      }
      _renderedIds = todoList.toList();
    });
  }

  void append(String id) {
    print('> TodoListView -> append id = ${id}');
    dom.insertBefore(TodoListItemView(id).dom, dom.firstChild);
  }

  var _renderedIds = [];
}
