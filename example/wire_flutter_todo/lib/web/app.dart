// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart';

import 'package:wire_example_shared/todo/view/web/clear_completed_view.dart';
import 'package:wire_example_shared/todo/view/web/complete_all_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_count_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_filter_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_input_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_list_view.dart';

// Copy of application from Wire Dart repo example TodoMVC
class TodoAppWeb {
  TodoAppWeb() {
    final domNewTodoInput = window.document.querySelector('.new-todo')!;
    final domTodoList = window.document.querySelector('.todo-list')!;
    final domTodoCount = window.document.querySelector('.todo-count')!.firstChild;
    final domFiltersList = window.document.querySelector('.filters')!;
    final domToggleAll = window.document.querySelector('.toggle-all')!;
    final domClearCompleted = window.document.querySelector('.clear-completed')!;

    TodoInputView(domNewTodoInput as HTMLInputElement);
    TodoListView(domTodoList as HTMLUListElement);
    TodoCountView(domTodoCount as Element);
    TodoFilterView(domFiltersList as HTMLUListElement);
    CompleteAllView(domToggleAll as HTMLInputElement);
    ClearCompletedView(domClearCompleted as HTMLButtonElement);
  }
}
