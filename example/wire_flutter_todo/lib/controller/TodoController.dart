import 'package:wire/wire.dart';

import '../const/FilterValues.dart';
import '../const/ViewSignal.dart';
import '../data/dto/CreateDTO.dart';
import '../model/TodoModel.dart';
import '../data/dto/EditDTO.dart';

class TodoController {
  TodoModel todoModel;
  TodoController(this.todoModel) {

    /*
    Wire.add(this, TodoViewSignal.INPUT, (data) {s
      var text = data as String;
      print('> TodoProcessor -> TodoViewOutputSignal.INPUT: ' + text);
      if (text != null && text.isNotEmpty) {
        todoModel.create(text);
        Wire.send(TodoViewSignal.CLEAR);
      }
    });

    Wire.add(this, TodoViewSignal.DELETE, (data) {
      var todoId = data as String;
      print('> TodoProcessor -> TodoViewOutputSignal.DELETE: ' + todoId);
      todoModel.remove(todoId);
    });
    * */

    Wire.add(this, TodoViewSignal.INPUT,  _signalProcessor);
    Wire.add(this, TodoViewSignal.EDIT,   _signalProcessor);
    Wire.add(this, TodoViewSignal.DELETE, _signalProcessor);
    Wire.add(this, TodoViewSignal.TOGGLE, _signalProcessor);
    Wire.add(this, TodoViewSignal.FILTER, _signalProcessor);
    Wire.add(this, TodoViewSignal.CLEAR_COMPLETED, _signalProcessor);
    Wire.add(this, TodoViewSignal.COMPLETE_ALL, _signalProcessor);

    print('Processor Ready');
  }

  void _signalProcessor(dynamic data, int wid) {
    var wire = Wire.get(wid: wid).single;
    print('> TodoProcessor -> ${wire.signal}: data = ' + data.toString());
    switch (wire.signal) {
      case TodoViewSignal.INPUT:
        var createDTO = data as CreateDTO;
        var text = createDTO.text;
        var note = createDTO.note;
        var completed = createDTO.completed;
        if (text != null && text.isNotEmpty) {
          todoModel.create(text, note, completed);
          Wire.send(TodoViewSignal.CLEAR_INPUT);
        }
        break;
      case TodoViewSignal.EDIT:
        var editTodoDTO = data as EditDTO;
        var todoText = editTodoDTO.text;
        var todoNote = editTodoDTO.note;
        var todoId = editTodoDTO.id;
        if (todoText.isEmpty) {
          todoModel.remove(todoId);
        } else {
          todoModel.update(todoId, todoText, todoNote);
        }
        break;
      case TodoViewSignal.TOGGLE:
        var todoId = data as String;
        todoModel.toggle(todoId);
        break;
      case TodoViewSignal.DELETE:
        var todoId = data as String;
        todoModel.remove(todoId);
        break;
      case TodoViewSignal.FILTER:
        var filter = data as TodoFilterValue;
        todoModel.filter(filter);
        break;
      case TodoViewSignal.CLEAR_COMPLETED:
        todoModel.clearCompleted();
        break;
      case TodoViewSignal.COMPLETE_ALL:
        var completed = data as bool;
        todoModel.setCompletionToAll(completed);
        break;
    }
  }
}