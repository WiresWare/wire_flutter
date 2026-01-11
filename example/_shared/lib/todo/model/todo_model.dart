import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';
import 'package:wire_example_shared/todo/service/abstract_database_service.dart';

class TodoModel {
  TodoModel(this._dbService) {
    whenReady = Future(() async {
      final idsList = <String>[];
      var notCompletedCount = 0;
      print('> TodoModel -> init: _dbService.exist = ${_dbService.exist(STORAGE_KEY)}');
      if (_dbService.exist(STORAGE_KEY)) {
        try {
          for (final obj in await _dbService.retrieve(STORAGE_KEY) as List<dynamic>) {
            print('> TodoModel -> init: todo = $obj');
            if (obj != null) {
              final todoVO = TodoVO.fromJson(obj as Map<dynamic, dynamic>);
              Wire.data<TodoVO>(todoVO.id, value: todoVO);
              idsList.add(todoVO.id);
              if (!todoVO.completed) notCompletedCount++;
            }
          }
        } catch (e) {
          print('> TodoModel -> init: Error loading form local storage: $e');
          return Future.value(false);
        }
      }
      print('> TodoModel -> init: list = ${idsList.length}');
      print('> TodoModel -> init: count = $notCompletedCount');
      final bool isCompleteAll = await _dbService.retrieve(STORAGE_KEY_COMPLETE_ALL) as bool? ?? notCompletedCount == 0;

      Wire.data<List<String>>(DataKeys.LIST_OF_IDS, value: idsList);
      Wire.data<int>(DataKeys.COUNT, value: notCompletedCount);
      Wire.data<bool>(DataKeys.COMPLETE_ALL, value: isCompleteAll);
      return Future.value(true);
    });
  }

  static const String STORAGE_KEY = 'todo-mvc-dart-wire';
  static const String STORAGE_KEY_COMPLETE_ALL = '$STORAGE_KEY-complete-all';

  final IDatabaseService _dbService;
  late Future<bool> whenReady;

  List<String> get todoIdsList => Wire.data<List<String>>(DataKeys.LIST_OF_IDS).value ?? [];
  set todoIdsList(List<String> value) => Wire.data<List<String>>(DataKeys.LIST_OF_IDS, value: value);

  int get todosCount => Wire.data<int>(DataKeys.COUNT).value ?? 0;
  set todosCount(int value) => Wire.data<int>(DataKeys.COUNT, value: value);

  TodoVO create(String text, String note, bool completed) {
    final newTodoId = DateTime.now().millisecondsSinceEpoch.toString();
    final newTodoVO = TodoVO(newTodoId, text, note, completed);

    todoIdsList.add(newTodoId);

    // Add Todo to data layer
    Wire.data<TodoVO>(newTodoVO.id, value: newTodoVO);
    // Update TodoList in data layer
    todoIdsList = todoIdsList;
    // Update Todo complete counter
    todosCount = todosCount + (completed ? 0 : 1);

    _checkOnCompleteAll();
    _saveChanges();

    print('> TodoModel -> created: ${newTodoVO.id} - ${newTodoVO.text}');
    return newTodoVO;
  }

  Future<TodoVO> remove(String id) async {
    final wireDataTodoVO = Wire.data<TodoVO>(id);
    final todoVO = wireDataTodoVO.value!;

    todoIdsList.remove(id);
    await wireDataTodoVO.remove();

    if (todoVO.completed == false) {
      todosCount = todosCount - 1;
    }

    todoIdsList = todoIdsList;

    _saveChanges();

    print('> TodoModel -> removed: $id');
    return todoVO;
  }

  TodoVO update(String id, String text, String note) {
    final wireDateTodoVO = Wire.data<TodoVO>(id);
    final todoVO = wireDateTodoVO.value!;
    todoVO.text = text;
    todoVO.note = note;

    wireDateTodoVO.refresh(); // this way won't update middlewares only direct write will: Wire.data<TodoVO>(id, todoVO);

    _saveChanges();

    print('> TodoModel -> updated: ${todoVO.id} - ${todoVO.text}');
    return todoVO;
  }

  TodoVO toggle(String id) {
    final wireDataTodoVO = Wire.data<TodoVO>(id);
    final todoVO = wireDataTodoVO.value!;
    final wasCompleted = todoVO.completed;

    todoVO.completed = !todoVO.completed;

    Wire.data<TodoVO>(id, value: todoVO);
    todosCount = todosCount + (todoVO.completed ? -1 : 1);

    if (wasCompleted) _checkOnCompleteAll();

    _saveChanges();

    print('> TodoModel -> toggled: id = ${todoVO.id} - ${todoVO.completed} - ${todoVO.text}');
    return todoVO;
  }

  void filter(FilterValues filter) {
    for (final id in todoIdsList) {
      final todoWireData = Wire.data<TodoVO>(id);
      final todoVO = todoWireData.value!;
      bool todoVisible = todoVO.visible;
      switch (filter) {
        case FilterValues.ALL:
          todoVisible = true;
          break;
        case FilterValues.ACTIVE:
          todoVisible = !todoVO.completed;
          break;
        case FilterValues.COMPLETED:
          todoVisible = todoVO.completed;
          break;
      }
      if (todoVO.visible != todoVisible) {
        todoVO.visible = todoVisible;
        Wire.data<TodoVO>(id, value: todoVO);
      }
    }
    Wire.data<FilterValues>(DataKeys.FILTER, value: filter);
    print('> TodoModel -> filtered: $filter');
  }

  void setCompletionToAll(bool completeAll) {
    var count = todosCount;
    print('> TodoModel -> setCompletionToAll: $completeAll - $count');
    for (final id in todoIdsList) {
      final todoWireData = Wire.data<TodoVO>(id);
      final todoVO = todoWireData.value!;
      if (todoVO.completed != completeAll) {
        count += completeAll ? -1 : 1;
        todoVO.completed = completeAll;
        Wire.data<TodoVO>(id, value: todoVO);
      }
    }
    todosCount = count;
    Wire.data<bool>(DataKeys.COMPLETE_ALL, value: completeAll);

    _saveChanges();
  }

  void clearCompleted() {
    final List<WireData<TodoVO>> listToRemove = [];
    todoIdsList.removeWhere((tid) {
      final todoWireData = Wire.data<TodoVO>(tid);
      if (todoWireData.isSet == false) return false;
      final completed = todoWireData.value!.completed;
      if (completed) {
        print('> \t\t completed: $tid');
        listToRemove.add(todoWireData);
      }
      return completed;
    });

    Future.forEach(listToRemove, (WireData<TodoVO> todoWireData) async => todoWireData.remove());
    todoIdsList = todoIdsList;

    _saveChanges();

    print('> TodoModel -> clearCompleted: length = ${todoIdsList.length}');
  }

  void _checkOnCompleteAll() {
    final completeAllWireData = Wire.data<bool>(DataKeys.COMPLETE_ALL);
    final bool completeAll = completeAllWireData.isSet && (completeAllWireData.value ?? false);
    print('> TodoModel -> _checkOnCompleteAll: completeAll = $completeAll');
    if (completeAll) {
      Wire.data<bool>(DataKeys.COMPLETE_ALL, value: false);
      Wire.send(ViewSignals.COMPLETE_ALL_FORCED, payload: false);
    }
  }

  void _saveChanges() {
    final List<Map<dynamic, dynamic>> listOfTodoVO = [];
    for (final id in todoIdsList) {
      final todo = Wire.data<TodoVO>(id).value;
      if (todo != null) {
        listOfTodoVO.add(todo.toJson());
      }
    }
    _dbService.save(STORAGE_KEY, listOfTodoVO);
    // Can't save to the same storage type on mobile
    // _dbService.save(STORAGE_KEY_COMPLETE_ALL, Wire.data(DataKeys.COMPLETE_ALL).value as bool);
  }
}
