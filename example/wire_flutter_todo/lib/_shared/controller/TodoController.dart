import 'package:wire/wire.dart';

import '../const/FilterValues.dart';
import '../const/ViewSignals.dart';
import '../data/dto/CreateDTO.dart';
import '../model/TodoModel.dart';
import '../data/dto/EditDTO.dart';

class TodoController {
  TodoModel todoModel;
  TodoController(this.todoModel) {

    /*
    Wire.add(this, ViewSignals.INPUT, (data) {s
      var text = data as String;
      print('> TodoProcessor -> TodoViewOutputSignal.INPUT: ' + text);
      if (text != null && text.isNotEmpty) {
        todoModel.create(text);
        Wire.send(ViewSignals.CLEAR);
      }
    });

    Wire.add(this, ViewSignals.DELETE, (data) {
      var todoId = data as String;
      print('> TodoProcessor -> TodoViewOutputSignal.DELETE: ' + todoId);
      todoModel.remove(todoId);
    });
    * */

    Wire.add(this, ViewSignals.INPUT,  _signalProcessor);
    Wire.add(this, ViewSignals.EDIT,   _signalProcessor);
    Wire.add(this, ViewSignals.DELETE, _signalProcessor);
    Wire.add(this, ViewSignals.TOGGLE, _signalProcessor);
    Wire.add(this, ViewSignals.FILTER, _signalProcessor);
    Wire.add(this, ViewSignals.CLEAR_COMPLETED, _signalProcessor);
    Wire.add(this, ViewSignals.COMPLETE_ALL, _signalProcessor);

    print('Processor Ready');
  }

  void _signalProcessor(dynamic data, int wid) {
    var wire = Wire.get(wid: wid).single;
    print('> TodoProcessor -> ${wire.signal}: data = ' + data.toString());
    switch (wire.signal) {
      case ViewSignals.INPUT:
        var createDTO = data as CreateDTO;
        var text = createDTO.text;
        var note = createDTO.note;
        var completed = createDTO.completed;
        if (text != null && text.isNotEmpty) {
          todoModel.create(text, note, completed);
          Wire.send(ViewSignals.CLEAR_INPUT);
        }
        break;
      case ViewSignals.EDIT:
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
      case ViewSignals.TOGGLE:
        var todoId = data as String;
        todoModel.toggle(todoId);
        break;
      case ViewSignals.DELETE:
        var todoId = data as String;
        todoModel.remove(todoId);
        break;
      case ViewSignals.FILTER:
        var filter = data as FilterValues;
        todoModel.filter(filter);
        break;
      case ViewSignals.CLEAR_COMPLETED:
        todoModel.clearCompleted();
        break;
      case ViewSignals.COMPLETE_ALL:
        var completed = data as bool;
        todoModel.setCompletionToAll(completed);
        break;
    }
  }
}
