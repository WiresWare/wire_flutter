import 'package:wire/wire.dart';
import '../const/DataKeys.dart';
import '../const/FilterValues.dart';
import '../service/IDatabaseService.dart';
import '../data/vo/TodoVO.dart';

class TodoModel {
  static const String LOCAL_STORAGE_KEY = 'todo-mvc-dart-wire';

  final IDatabaseService _dbService;
  bool _isFlutter;

  TodoModel(this._dbService, {bool isFlutter = true}) {
    _isFlutter = isFlutter;
    var idsList = <String>[];
    var notCompletedCount = 0;
    if (_dbService.exist(LOCAL_STORAGE_KEY)) {
      try {
        _dbService.retrieve(LOCAL_STORAGE_KEY).forEach((obj){
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
    Wire.data<List<String>>(DataKeys.LIST, value: idsList);
    Wire.data<int>(DataKeys.COUNT, value: notCompletedCount);
  }

  TodoVO create(String text, String note, bool completed) {
    final time = DateTime.now().millisecondsSinceEpoch;
    final id = time.toString();
    final todoVO = TodoVO(id, text, note, completed);
    final listData = Wire.data(DataKeys.LIST);
    final todoList = listData.value as List;
    final count = Wire.data<int>(DataKeys.COUNT).value;

    todoList.add(todoVO.id);
    Wire.data<TodoVO>(todoVO.id, value: todoVO);
    Wire.data<List<String>>(DataKeys.LIST, value: todoList);
    Wire.data<int>(DataKeys.COUNT, value: count + (completed ? 0 : 1));

    _save();

    print('> TodoModel -> created: ' + todoVO.id + ' - ' + todoVO.text);
    return todoVO;
  }

  TodoVO remove(String id) {
    final todoList = Wire.data<List<String>>(DataKeys.LIST).value;
    final count = Wire.data<int>(DataKeys.COUNT).value as int;
    final todoWireData = Wire.data<TodoVO>(id);
    final todoVO = todoWireData.value;

    todoList.remove(id);
    todoWireData.remove();

    if (todoVO.completed == false) {
      Wire.data(DataKeys.COUNT, value: count - 1);
    }

    if (_isFlutter) {
      // Only difference with web version in Wire repositories (example TodoMVC)
      Wire.data<List<String>>(DataKeys.LIST, value: todoList);
    }

    _save();

    print('> TodoModel -> removed: ' + id);
    return todoVO;
  }

  TodoVO update(String id, String text, String note) {
    final todoWireData = Wire.data<TodoVO>(id);
    final todoVO = todoWireData.value;
    todoVO.text = text;
    todoVO.note = note;
    // Wire.data<TodoVO>(id, todoVO);
    todoWireData.refresh();
    _save();

    print('> TodoModel -> updated: ' + todoVO.id + ' - ' + todoVO.text);
    return todoVO;
  }

  TodoVO toggle(String id) {
    final todoWireData = Wire.data(id);
    final todoVO = todoWireData.value as TodoVO;
    final count = Wire.data(DataKeys.COUNT).value as int;

    todoVO.completed = !todoVO.completed;

    Wire.data(id, value: todoVO);
    Wire.data(DataKeys.COUNT, value: count + (todoVO.completed ? -1 : 1));

    _save();

    print('> TodoModel -> toggled: ' + todoVO.id + ' - ' + todoVO.text);
    return null;
  }

  void filter(FilterValues filter) {
    final todoList = Wire.data(DataKeys.LIST).value as List;
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
    Wire.data(DataKeys.FILTER, value: filter);
    print('> TodoModel -> filtered: ' + filter.toString());
  }

  void setCompletionToAll(value) {
    final todoList = Wire.data(DataKeys.LIST).value as List;
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
    _save();
  }

  void clearCompleted() {
    final todoList = Wire.data(DataKeys.LIST).value as List;
    todoList.removeWhere((id) {
      var todoWireData = Wire.data(id);
      var todoVO = todoWireData.value as TodoVO;
      if (todoVO.completed) {
        todoWireData.remove();
      }
      return todoVO.completed;
    });

    if (_isFlutter) {
      Wire.data(DataKeys.LIST, value: todoList);
    }

    _save();

    print('> TodoModel -> clearCompleted: length = ' + todoList.length.toString());
  }

  void _save() {
    var listToSave = <TodoVO>[];
    (Wire.data(DataKeys.LIST).value as List).forEach((id) =>
      listToSave.add(Wire.data(id).value)
    );
    _dbService.save(LOCAL_STORAGE_KEY, listToSave);
  }
}
