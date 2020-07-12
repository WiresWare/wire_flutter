import 'package:flutter/widgets.dart';

class ArchSampleKeys {
  static var addTodoScreen = UniqueKey();
  static var saveTodoFab = UniqueKey();
  static var saveNewTodo = UniqueKey();
  static var taskField = UniqueKey();
  static var noteField = UniqueKey();
  static var todoDetailsScreen = UniqueKey();
  static var deleteTodoButton = UniqueKey();
  static var detailsTodoItemCheckbox = UniqueKey();
  static var detailsTodoItemTask = UniqueKey();
  static var detailsTodoItemNote = UniqueKey();
  static var editTodoFab = UniqueKey();
  static var homeScreen = UniqueKey();
  static var addTodoFab = UniqueKey();
  static var statsTab = UniqueKey();
  static var todoTab = UniqueKey();
  static var tabs = UniqueKey();
  static var statsCounter = UniqueKey();
  static var statsNumCompleted = UniqueKey();
  static var statsNumActive = UniqueKey();
  static var todosLoading = UniqueKey();
  static var todoList = UniqueKey();
  static var snackbar = UniqueKey();
  static var toggleAll = UniqueKey();
  static var clearCompleted = UniqueKey();
  static var extraActionsButton = UniqueKey();
  static var filterButton = UniqueKey();
  static var allFilter = UniqueKey();
  static var activeFilter = UniqueKey();
  static var completedFilter = UniqueKey();

  static todoItemCheckbox(id) { return Key(id); }
  static todoItemTask(id) { return Key(id); }
  static todoItemNote(id) { return Key(id); }
  static todoItem(id) { return Key(id); }

}