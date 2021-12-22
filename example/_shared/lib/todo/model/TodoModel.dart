import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import '../const/DataKeys.dart';
import '../const/FilterValues.dart';
import '../service/IDatabaseService.dart';
import '../data/vo/TodoVO.dart';

class TodoModel {
  static const String LOCAL_STORAGE_KEY = 'todo-mvc-dart-wire';
  static const String LOCAL_STORAGE_KEY_COMPLETE_ALL = '$LOCAL_STORAGE_KEY-complete-all';

  final IDatabaseService _dbService;

  TodoModel(this._dbService) {
    var idsList = <String>[];
    var notCompletedCount = 0;
    if (_dbService.exist(LOCAL_STORAGE_KEY)) {
      try {
        _dbService.retrieve(LOCAL_STORAGE_KEY).forEach((obj) {
          if (obj != null) {
            var todoVO = TodoVO.fromJson(obj);
            Wire.data<TodoVO>(todoVO.id, value: todoVO);
            idsList.add(todoVO.id);
            if (!todoVO.completed) notCompletedCount++;
          }
        });
      } catch (e) {
        print('Error loading form local storage: ' + e.toString());
      }
    }
    print('> TodoModel list: ${idsList.length}');
    print('> TodoModel count: ${notCompletedCount}');
    Wire.data<List<String>>(DataKeys.LIST_OF_IDS, value: idsList);
    Wire.data<int>(DataKeys.COUNT, value: notCompletedCount);
    Wire.data(DataKeys.COMPLETE_ALL, value: _dbService.retrieve(LOCAL_STORAGE_KEY_COMPLETE_ALL));
  }

  TodoVO create(String text, String note, bool completed) {
    final newTodoId = DateTime.now().millisecondsSinceEpoch.toString();
    final newTodoVO = TodoVO(newTodoId, text, note, completed);
    final todoIdsList = Wire.data(DataKeys.LIST_OF_IDS).value!;
    final count = Wire.data<int>(DataKeys.COUNT).value;

    todoIdsList.add(newTodoId);

    Wire.data<TodoVO>(newTodoVO.id, value: newTodoVO);
    Wire.data<List<String>>(DataKeys.LIST_OF_IDS, value: todoIdsList);
    Wire.data<int>(DataKeys.COUNT, value: count + (completed ? 0 : 1));

    _checkOnCompleteAll();
    _saveChanges();

    print('> TodoModel -> created: ' + newTodoVO.id + ' - ' + newTodoVO.text);
    return newTodoVO;
  }

  Future<TodoVO> remove(String id) async {
    final todoIdsList = Wire.data<List<String>>(DataKeys.LIST_OF_IDS).value!;
    final count = Wire.data<int>(DataKeys.COUNT).value as int;
    final wireDataTodoVO = Wire.data<TodoVO>(id);
    final todoVO = wireDataTodoVO.value;

    todoIdsList.remove(id);
    await wireDataTodoVO.remove();

    if (todoVO.completed == false) {
      Wire.data(DataKeys.COUNT, value: count - 1);
    }

    Wire.data<List<String>>(DataKeys.LIST_OF_IDS, value: todoIdsList);

    _saveChanges();

    print('> TodoModel -> removed: ' + id);
    return todoVO;
  }

  TodoVO update(String id, String text, String note) {
    final wireDateTodoVO = Wire.data<TodoVO>(id);
    final todoVO = wireDateTodoVO.value;
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

    Wire.data(id, value: todoVO);
    Wire.data(DataKeys.COUNT, value: count + (todoVO.completed ? -1 : 1));

    if (wasCompleted) _checkOnCompleteAll();

    _saveChanges();

    print('> TodoModel -> toggled: ' + todoVO.id + ' - ' + todoVO.text);
    return todoVO;
  }

  void filter(FilterValues filter) {
    final todoList = Wire.data(DataKeys.LIST_OF_IDS).value as List;
    todoList.forEach((id) {
      var todoWireData = Wire.data(id);
      var todoVO = todoWireData.value as TodoVO;
      var todoVisible = todoVO.visible;
      switch (filter) {
        case FilterValues.ALL: todoVisible = true; break;
        case FilterValues.ACTIVE: todoVisible = !todoVO.completed; break;
        case FilterValues.COMPLETED: todoVisible = todoVO.completed; break;
      }
      if (todoVO.visible != todoVisible) {
        todoVO.visible = todoVisible;
        Wire.data(id, value: todoVO);
      }
    });
    Wire.data<FilterValues>(DataKeys.FILTER, value: filter);
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
    final completeAllWireData = Wire.data<bool>(DataKeys.COMPLETE_ALL);
    final completeAll = completeAllWireData.isSet ? completeAllWireData.value : false;
    if (completeAll > 0) {
      Wire.data(DataKeys.COMPLETE_ALL, value: false);
      Wire.send(ViewSignals.COMPLETE_ALL_FORCED, payload: false);
    }
  }

  void _saveChanges() {
    var listOfTodoVO = <TodoVO>[];
    (Wire.data(DataKeys.LIST_OF_IDS).value as List)
        .forEach((id) => listOfTodoVO.add(Wire.data(id).value));

    _dbService.save(LOCAL_STORAGE_KEY, listOfTodoVO);
    _dbService.save(LOCAL_STORAGE_KEY_COMPLETE_ALL, Wire.data(DataKeys.COMPLETE_ALL).value);
  }
}
