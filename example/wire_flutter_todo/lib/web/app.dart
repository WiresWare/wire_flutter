import 'dart:html';

import 'view/ClearCompletedView.dart';
import 'view/CompleteAllView.dart';
import 'view/TodoCountView.dart';
import 'view/TodoFilterView.dart';
import 'view/TodoInputView.dart';
import 'view/TodoListView.dart';

// Copy of application from Wire Dart repo example TodoMVC
class TodoAppWeb {
  TodoAppWeb() {
    final domNewTodoInput = document.querySelector('.new-todo');
    final domTodoList = document.querySelector('.todo-list');
    final domTodoCount = document.querySelector('.todo-count').firstChild;
    final domFiltersList = document.querySelector('.filters');
    final domToggleAll = document.querySelector('.toggle-all');
    final domClearCompleted = document.querySelector('.clear-completed');

    TodoInputView(domNewTodoInput as InputElement);
    TodoListView(domTodoList as UListElement);
    TodoCountView(domTodoCount as Element);
    TodoFilterView(domFiltersList as UListElement);
    CompleteAllView(domToggleAll as CheckboxInputElement);
    ClearCompletedView(domClearCompleted as ButtonElement);
  }
}
