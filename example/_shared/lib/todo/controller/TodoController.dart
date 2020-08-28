import 'package:wire/wire.dart';

import '../const/FilterValues.dart';
import '../const/ViewSignals.dart';
import '../data/base/DTO.dart';
import '../data/dto/InputDTO.dart';
import '../model/TodoModel.dart';
import '../data/dto/EditDTO.dart';

class TodoController {
  TodoModel todoModel;
  TodoController(this.todoModel) {


//    Wire.add(this, ViewSignals.INPUT, (String data, int wid) {
//      var text = data;
//      print('> TodoProcessor -> TodoViewOutputSignal.INPUT: ' + text);
//      if (text != null && text.isNotEmpty) {
//        todoModel.create(text);
//        Wire.send(ViewSignals.CLEAR_INPUT);
//      }
//    });
//
//    Wire.add(this, ViewSignals.DELETE, (String data, int wid) {
//      var todoId = data;
//      print('> TodoProcessor -> TodoViewOutputSignal.DELETE: ' + todoId);
//      todoModel.remove(todoId);
//    });


    Wire.add(this, ViewSignals.INPUT,  _signalProcessor);
    Wire.add(this, ViewSignals.EDIT,   _signalProcessor);
    Wire.add(this, ViewSignals.DELETE, _signalProcessor);
    Wire.add(this, ViewSignals.TOGGLE, _signalProcessor);
    Wire.add(this, ViewSignals.FILTER, _signalProcessor);
    Wire.add(this, ViewSignals.CLEAR_COMPLETED, _signalProcessor);
    Wire.add(this, ViewSignals.COMPLETE_ALL, _signalProcessor);

    print('Processor Ready');
  }

  void _signalProcessor(dynamic payload, int wid) {
    var wire = Wire.get(wid: wid).single;
    print('> TodoProcessor -> ${wire.signal}: data = ' + payload.toString());
    switch (wire.signal) {
      case ViewSignals.INPUT:
        var createDTO = payload as InputDTO;
        var text = createDTO.text;
        var note = createDTO.note;
        var completed = createDTO.completed;
        if (text != null && text.isNotEmpty) {
          todoModel.create(text, note, completed);
          Wire.send(ViewSignals.CLEAR_INPUT);
        }
        break;
      case ViewSignals.EDIT:
        var editTodoDTO = payload as EditDTO;
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
        var todoId = payload as String;
        todoModel.toggle(todoId);
        break;
      case ViewSignals.DELETE:
        var todoId = payload as String;
        todoModel.remove(todoId);
        break;
      case ViewSignals.FILTER:
        var filter = payload as FilterValues;
        todoModel.filter(filter);
        break;
      case ViewSignals.CLEAR_COMPLETED:
        todoModel.clearCompleted();
        break;
      case ViewSignals.COMPLETE_ALL:
        var completed = payload as bool;
        todoModel.setCompletionToAll(completed);
        break;
    }
  }
}
