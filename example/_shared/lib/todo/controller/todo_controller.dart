import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/data/dto/edit_dto.dart';
import 'package:wire_example_shared/todo/data/dto/input_dto.dart';
import 'package:wire_example_shared/todo/model/todo_model.dart';

class TodoController {
  TodoController(this.todoModel) {
    //    Wire.add(this, ViewSignals.INPUT, (String payload, int wireId) {
    //      final text = payload;
    //      print('> TodoProcessor -> TodoViewOutputSignal.INPUT: ' + text);
    //      if (text != null && text.isNotEmpty) {
    //        todoModel.create(text);
    //        Wire.send(ViewSignals.CLEAR_INPUT);
    //      }
    //    });
    //
    //    Wire.add(this, ViewSignals.DELETE, (String payload, int wireId) {
    //      final todoId = payload;
    //      print('> TodoProcessor -> TodoViewOutputSignal.DELETE: ' + todoId);
    //      todoModel.remove(todoId);
    //    });

    Wire.add(this, ViewSignals.INPUT, _signalProcessor);
    Wire.add(this, ViewSignals.EDIT, _signalProcessor);
    Wire.add(this, ViewSignals.DELETE, _signalProcessor);
    Wire.add(this, ViewSignals.TOGGLE, _signalProcessor);
    Wire.add(this, ViewSignals.FILTER, _signalProcessor);
    Wire.add(this, ViewSignals.CLEAR_COMPLETED, _signalProcessor);
    Wire.add(this, ViewSignals.COMPLETE_ALL, _signalProcessor);

    Wire.data(
      DataKeys.GET_COUNT_COMPLETED,
      getter: (that) {
        final listOfAllTodosWireData = Wire.data<List<String>>(DataKeys.LIST_OF_IDS);
        final notCompletedCountWireData = Wire.data<int>(DataKeys.COUNT);
        final int notCompletedCount = notCompletedCountWireData.value ?? 0;
        listOfAllTodosWireData.subscribe(that.refresh);
        notCompletedCountWireData.subscribe(that.refresh);
        return (listOfAllTodosWireData.value ?? []).length - notCompletedCount;
      },
    );

    print('Processor Ready');
  }

  TodoModel todoModel;

  Future<dynamic> _signalProcessor(dynamic payload, int wireId) async {
    final wire = Wire.get(wireId: wireId).single;
    print('> TodoProcessor -> ${wire.signal}: data = $payload');
    switch (wire.signal) {
      case ViewSignals.INPUT:
        final inputDTO = payload as InputDTO;
        final text = inputDTO.text;
        final note = inputDTO.note;
        final completed = inputDTO.completed;
        if (text.isNotEmpty) {
          final todoVO = todoModel.create(text, note, completed);
          Wire.send(ViewSignals.CLEAR_INPUT);
          return todoVO;
        } else {
          // Signalise about error or wrong input
          return null;
        }
      case ViewSignals.EDIT:
        final editTodoDTO = payload as EditDTO;
        final todoText = editTodoDTO.text;
        final todoNote = editTodoDTO.note;
        final todoId = editTodoDTO.id;
        if (todoText.isEmpty) {
          todoModel.remove(todoId);
        } else {
          todoModel.update(todoId, todoText, todoNote);
        }
        break;
      case ViewSignals.TOGGLE:
        final todoId = payload as String;
        todoModel.toggle(todoId);
        break;
      case ViewSignals.DELETE:
        final todoId = payload as String;
        todoModel.remove(todoId);
        break;
      case ViewSignals.FILTER:
        final filter = payload as FilterValues;
        todoModel.filter(filter);
        break;
      case ViewSignals.CLEAR_COMPLETED:
        todoModel.clearCompleted();
        break;
      case ViewSignals.COMPLETE_ALL:
        final completed = payload as bool;
        todoModel.setCompletionToAll(completed);
        break;
    }
  }
}
