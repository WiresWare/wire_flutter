// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:wire_example_shared/todo/view/web/ClearCompletedView.dart';
import 'package:wire_example_shared/todo/view/web/CompleteAllView.dart';
import 'package:wire_example_shared/todo/view/web/TodoCountView.dart';
import 'package:wire_example_shared/todo/view/web/TodoFilterView.dart';
import 'package:wire_example_shared/todo/view/web/TodoInputView.dart';
import 'package:wire_example_shared/todo/view/web/TodoListView.dart';

// Copy of application from Wire Dart repo example TodoMVC
class TodoAppWeb {
  TodoAppWeb() {
    final domNewTodoInput = document.querySelector('.new-todo')!;
    final domTodoList = document.querySelector('.todo-list')!;
    final domTodoCount = document.querySelector('.todo-count')!.firstChild;
    final domFiltersList = document.querySelector('.filters')!;
    final domToggleAll = document.querySelector('.toggle-all')!;
    final domClearCompleted = document.querySelector('.clear-completed')!;

    TodoInputView(domNewTodoInput as InputElement);
    TodoListView(domTodoList as UListElement);
    TodoCountView(domTodoCount as Element);
    TodoFilterView(domFiltersList as UListElement);
    CompleteAllView(domToggleAll as CheckboxInputElement);
    ClearCompletedView(domClearCompleted as ButtonElement);
  }
}
