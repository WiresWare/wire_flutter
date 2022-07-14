import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';

import '../const/DataKeys.dart';
import '../const/FilterValues.dart';
import '../data/vo/TodoVO.dart';
import '../service/IDatabaseService.dart';

class TodoModel {
  static const String STORAGE_KEY = 'todo-mvc-dart-wire';
  static const String STORAGE_KEY_COMPLETE_ALL = '$STORAGE_KEY-complete-all';

  final IDatabaseService _dbService;

  late Future<bool> whenReady;

  final todoItemLockToken = WireDataLockToken();

  TodoModel(this._dbService) {
    whenReady = new Future(() async {
      var idsList = <String>[];
      var notCompletedCount = 0;
      print('> TodoModel -> init: _dbService.exist = ${_dbService.exist(STORAGE_KEY)}');
      if (_dbService.exist(STORAGE_KEY)) {
        try {
          (await _dbService.retrieve(STORAGE_KEY) as List).forEach((obj) {
            print('> TodoModel -> init: todo = $obj');
            if (obj != null) {
              var todoVO = TodoVO.fromJson(obj);
              todoVO.isDeletable = true;
              Wire.data(todoVO.id, value: todoVO);
                  // .lock(todoItemLockToken);
              idsList.add(todoVO.id);
              if (!todoVO.completed) notCompletedCount++;
            }
          });
        } catch (e) {
          print('> TodoModel -> init: Error loading form local storage: ' + e.toString());
          return Future.value(false);
        }
      }
      print('> TodoModel -> init: list = ${idsList.length}');
      print('> TodoModel -> init: count = $notCompletedCount');
      final isCompleteAll = await _dbService.retrieve(STORAGE_KEY_COMPLETE_ALL) ?? notCompletedCount == 0;

      Wire.data(DataKeys.LIST_OF_IDS, value: idsList);
      Wire.data(DataKeys.COUNT, value: notCompletedCount);
      Wire.data(DataKeys.COMPLETE_ALL, value: isCompleteAll);
      return Future.value(true);
    });
  }

  TodoVO create(String text, String note, bool completed) {
    final newTodoId = DateTime.now().millisecondsSinceEpoch.toString();
    final newTodoVO = TodoVO(newTodoId, text, note, completed);
    final todoIdsList = Wire.data(DataKeys.LIST_OF_IDS).value!;
    final count = Wire.data(DataKeys.COUNT).value;

    todoIdsList.add(newTodoId);

    Wire.data(newTodoVO.id, value: newTodoVO);
    Wire.data(DataKeys.LIST_OF_IDS, value: todoIdsList);
    Wire.data(DataKeys.COUNT, value: count + (completed ? 0 : 1));

    _checkOnCompleteAll();
    _saveChanges();

    print('> TodoModel -> created: ' + newTodoVO.id + ' - ' + newTodoVO.text);
    return newTodoVO;
  }

  Future<TodoVO> remove(String id) async {
    final todoIdsList = Wire.data(DataKeys.LIST_OF_IDS).value!;
    final count = Wire.data(DataKeys.COUNT).value as int;
    final wireDataTodoVO = Wire.data(id);
    final todoVO = wireDataTodoVO.value;

    todoIdsList.remove(id);
    // wireDataTodoVO.unlock(todoItemLockToken);
    await wireDataTodoVO.remove();

    if (todoVO.completed == false) {
      Wire.data(DataKeys.COUNT, value: count - 1);
    }

    Wire.data(DataKeys.LIST_OF_IDS, value: todoIdsList);

    _saveChanges();

    print('> TodoModel -> removed: ' + id);
    return todoVO;
  }

  TodoVO update(String id, String text, String note) {
    final wireDateTodoVO = Wire.data(id);
    final todoVO = wireDateTodoVO.value as TodoVO;
    todoVO.text = text;
    todoVO.note = note;

    wireDateTodoVO.refresh(); // this way won't update middlewares only direct write will: Wire.data<TodoVO>(id, todoVO);

    _saveChanges();

    print('> TodoModel -> updated: ' + todoVO.id + ' - ' + todoVO.text);
    return todoVO;
  }

  TodoVO toggle(String id) {
    final wireDataTodoVO = Wire.data(id);
    final todoVO = wireDataTodoVO.value as TodoVO;
    final count = Wire.data(DataKeys.COUNT).value as int;
    final wasCompleted = todoVO.completed;

    todoVO.completed = !todoVO.completed;

    Wire.data(id).unlock(todoItemLockToken);
    Wire.data(id, value: todoVO);
    Wire.data(id).lock(todoItemLockToken);
    Wire.data(DataKeys.COUNT, value: count + (todoVO.completed ? -1 : 1));

    if (wasCompleted) _checkOnCompleteAll();

    _saveChanges();

    print('> TodoModel -> toggled: id = ${todoVO.id} - ${todoVO.completed} - ${todoVO.text}');
    return todoVO;
  }

  void filter(FilterValues filter) {
    final todoList = Wire.data(DataKeys.LIST_OF_IDS).value as List;
    todoList.forEach((id) {
      var todoWireData = Wire.data(id);
      var todoVO = todoWireData.value as TodoVO;
      var todoVisible = todoVO.visible;
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
    });
    Wire.data(DataKeys.FILTER, value: filter);
    print('> TodoModel -> filtered: ' + filter.toString());
  }

  void setCompletionToAll(value) {
    final todoList = Wire.data(DataKeys.LIST_OF_IDS).value as List;
    var count = Wire.data(DataKeys.COUNT).value as int;
    print('> TodoModel -> setCompletionToAll: $value - ' + count.toString());
    todoList.forEach((id) {
      var todoWireData = Wire.data(id);
      var todoVO = todoWireData.value as TodoVO;
      if (todoVO.completed != value) {
        count += value ? -1 : 1;
        todoVO.completed = value;
        Wire.data(id, value: todoVO);
      }
    });
    Wire.data(DataKeys.COUNT, value: count);
    Wire.data(DataKeys.COMPLETE_ALL, value: value);

    _saveChanges();
  }

  void clearCompleted() async {
    final List<String> todoIdsList = Wire.data(DataKeys.LIST_OF_IDS).value;
    final List<WireData> listToRemove = [];
    todoIdsList.removeWhere((tid) {
      final todoWireData = Wire.data(tid);
      final completed = todoWireData.value.completed;
      if (completed) {
        print('> \t\t completed: $tid');
        listToRemove.add(todoWireData);
      }
      return completed;
    });

    Future.forEach(listToRemove, (WireData todoWireData) async => await todoWireData.remove());
    Wire.data(DataKeys.LIST_OF_IDS, value: todoIdsList);

    _saveChanges();

    print('> TodoModel -> clearCompleted: length = ' + todoIdsList.length.toString());
  }

  void _checkOnCompleteAll() {
    final completeAllWireData = Wire.data(DataKeys.COMPLETE_ALL);
    final bool completeAll = completeAllWireData.isSet ? completeAllWireData.value : false;
    print('> TodoModel -> _checkOnCompleteAll: completeAll = $completeAll');
    if (completeAll) {
      Wire.data(DataKeys.COMPLETE_ALL, value: false);
      Wire.send(ViewSignals.COMPLETE_ALL_FORCED, payload: false);
    }
  }

  void _saveChanges() {
    var listOfTodoVO = [];
    (Wire.data(DataKeys.LIST_OF_IDS).value as List).forEach((id) {
      final todo = Wire.data(id).value;
      print('> TodoModel -> id: ${id}, todo = ${todo}');
      if (todo != null) listOfTodoVO.add(todo.toJson());
    });

    _dbService.save(STORAGE_KEY, listOfTodoVO);
    _dbService.save(STORAGE_KEY_COMPLETE_ALL, Wire.data(DataKeys.COMPLETE_ALL).value as bool);
  }
}
