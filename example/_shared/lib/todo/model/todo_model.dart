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
          for (final obj in await _dbService.retrieve(STORAGE_KEY) as List) {
            print('> TodoModel -> init: todo = $obj');
            if (obj != null) {
              final todoVO = TodoVO.fromJson(obj as Map<String, dynamic>);
              Wire.data(todoVO.id, value: todoVO);
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

      Wire.data(DataKeys.LIST_OF_IDS, value: idsList);
      Wire.data(DataKeys.COUNT, value: notCompletedCount);
      Wire.data(DataKeys.COMPLETE_ALL, value: isCompleteAll);
      return Future.value(true);
    });
  }

  static const String STORAGE_KEY = 'todo-mvc-dart-wire';
  static const String STORAGE_KEY_COMPLETE_ALL = '$STORAGE_KEY-complete-all';

  final IDatabaseService _dbService;
  late Future<bool> whenReady;

  TodoVO create(String text, String note, bool completed) {
    final newTodoId = DateTime.now().millisecondsSinceEpoch.toString();
    final newTodoVO = TodoVO(newTodoId, text, note, completed);

    final todoIdsList = Wire.data(DataKeys.LIST_OF_IDS).value as List<String>;
    final count = Wire.data(DataKeys.COUNT).value as int;

    todoIdsList.add(newTodoId);

    // Add Todo to data layer
    Wire.data(newTodoVO.id, value: newTodoVO);
    // Update TodoList in data layer
    Wire.data(DataKeys.LIST_OF_IDS, value: todoIdsList);
    // Update Todo complete counter
    Wire.data(DataKeys.COUNT, value: count + (completed ? 0 : 1));

    _checkOnCompleteAll();
    _saveChanges();

    print('> TodoModel -> created: ${newTodoVO.id} - ${newTodoVO.text}');
    return newTodoVO;
  }

  Future<TodoVO> remove(String id) async {
    final todoIdsList = Wire.data(DataKeys.LIST_OF_IDS).value as List<String>;
    final count = Wire.data(DataKeys.COUNT).value as int;
    final wireDataTodoVO = Wire.data(id);
    final todoVO = wireDataTodoVO.value as TodoVO;

    todoIdsList.remove(id);
    await wireDataTodoVO.remove();

    if (todoVO.completed == false) {
      Wire.data(DataKeys.COUNT, value: count - 1);
    }

    Wire.data(DataKeys.LIST_OF_IDS, value: todoIdsList);

    _saveChanges();

    print('> TodoModel -> removed: $id');
    return todoVO;
  }

  TodoVO update(String id, String text, String note) {
    final wireDateTodoVO = Wire.data(id);
    final todoVO = wireDateTodoVO.value as TodoVO;
    todoVO.text = text;
    todoVO.note = note;

    wireDateTodoVO
        .refresh(); // this way won't update middlewares only direct write will: Wire.data<TodoVO>(id, todoVO);

    _saveChanges();

    print('> TodoModel -> updated: ${todoVO.id} - ${todoVO.text}');
    return todoVO;
  }

  TodoVO toggle(String id) {
    final wireDataTodoVO = Wire.data(id);
    final todoVO = wireDataTodoVO.value as TodoVO;
    final count = Wire.data(DataKeys.COUNT).value as int;
    final wasCompleted = todoVO.completed;

    todoVO.completed = !todoVO.completed;

    Wire.data(id, value: todoVO);
    Wire.data(DataKeys.COUNT, value: count + (todoVO.completed ? -1 : 1));

    if (wasCompleted) _checkOnCompleteAll();

    _saveChanges();

    print('> TodoModel -> toggled: id = ${todoVO.id} - ${todoVO.completed} - ${todoVO.text}');
    return todoVO;
  }

  void filter(FilterValues filter) {
    final todoList = Wire.data(DataKeys.LIST_OF_IDS).value as List<String>;
    for (final id in todoList) {
      final todoWireData = Wire.data(id);
      final todoVO = todoWireData.value as TodoVO;
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
        Wire.data(id, value: todoVO);
      }
    }
    Wire.data(DataKeys.FILTER, value: filter);
    print('> TodoModel -> filtered: $filter');
  }

  void setCompletionToAll(bool value) {
    final todoList = Wire.data(DataKeys.LIST_OF_IDS).value as List<String>;
    var count = Wire.data(DataKeys.COUNT).value as int;
    print('> TodoModel -> setCompletionToAll: $value - $count');
    for (final id in todoList) {
      final todoWireData = Wire.data(id);
      final todoVO = todoWireData.value as TodoVO;
      if (todoVO.completed != value) {
        count += value ? -1 : 1;
        todoVO.completed = value;
        Wire.data(id, value: todoVO);
      }
    }
    Wire.data(DataKeys.COUNT, value: count);
    Wire.data(DataKeys.COMPLETE_ALL, value: value);

    _saveChanges();
  }

  void clearCompleted() {
    final todoIdsList = Wire.data(DataKeys.LIST_OF_IDS).value as List<String>;
    final List<WireData> listToRemove = [];
    todoIdsList.removeWhere((tid) {
      final todoWireData = Wire.data(tid);
      final completed = (todoWireData.value as TodoVO).completed;
      if (completed) {
        print('> \t\t completed: $tid');
        listToRemove.add(todoWireData);
      }
      return completed;
    });

    Future.forEach(listToRemove, (WireData todoWireData) async => todoWireData.remove());
    Wire.data(DataKeys.LIST_OF_IDS, value: todoIdsList);

    _saveChanges();

    print('> TodoModel -> clearCompleted: length = ${todoIdsList.length}');
  }

  void _checkOnCompleteAll() {
    final completeAllWireData = Wire.data(DataKeys.COMPLETE_ALL);
    final bool completeAll = completeAllWireData.isSet && (completeAllWireData.value as bool);
    print('> TodoModel -> _checkOnCompleteAll: completeAll = $completeAll');
    if (completeAll) {
      Wire.data(DataKeys.COMPLETE_ALL, value: false);
      Wire.send(ViewSignals.COMPLETE_ALL_FORCED, payload: false);
    }
  }

  void _saveChanges() {
    final List<Map<String, dynamic>> listOfTodoVO = [];
    for (final id in Wire.data(DataKeys.LIST_OF_IDS).value as List<String>) {
      listOfTodoVO.add((Wire.data(id).value as TodoVO).toJson());
    }
    _dbService.save(STORAGE_KEY, listOfTodoVO);
    // Can't save to the same storage type on mobile
    // _dbService.save(STORAGE_KEY_COMPLETE_ALL, Wire.data(DataKeys.COMPLETE_ALL).value as bool);
  }
}
