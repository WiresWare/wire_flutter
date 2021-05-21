import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import 'package:wire_example_shared/todo/data/dto/EditDTO.dart';
import 'package:wire_example_shared/todo/data/vo/TodoVO.dart';
import 'base/DomElementView.dart';

class TodoListItemView extends DomElement {
  final inpToggle = InputElement()
    ..className = 'toggle'
    ..type = 'checkbox';

  final lblContent = LabelElement()..className = 'todo-content';
  final btnDelete = ButtonElement()..className = 'destroy';
  final inpEdit = InputElement()..className = 'edit';
  final container = DivElement()..className = 'view';

  final listeners = <StreamSubscription>[];

  final id;

  TodoListItemView(this.id) : super(LIElement()) {
    listeners.addAll([
      inpToggle.onClick.listen(_onToggle),
      btnDelete.onClick.listen(_onDelete),
      inpEdit.onKeyDown.listen(_onEditKeyboardInput),
      inpEdit.onBlur.listen((_) => _onEditCancel()),
      lblContent.onDoubleClick.listen((_) => _onEditBegin()),
    ]);

    var todoWireData = Wire.data(id);
    todoWireData.subscribe(_onTodoDataChanged);
    if (todoWireData.isSet) _onTodoDataChanged(todoWireData.value);

    container.append(inpToggle);
    container.append(lblContent);
    container.append(btnDelete);

    dom.append(inpEdit);
    dom.append(container);
  }

  void remove() {
    Wire.data(dom.id).unsubscribe(_onTodoDataChanged);
    listeners.every((element) {
      element.cancel();
      return true;
    });
    dom.remove();
  }

  void update(TodoVO todoVO) {
    dom.id = todoVO.id;
    dom.style.display = todoVO.visible ? 'block' : 'none';

    if (todoVO.visible) {
      var text = htmlEscape.convert(todoVO.text);
      dom.className = todoVO.completed ? 'completed' : '';
      inpToggle.checked = todoVO.completed;
      lblContent.text = text;
      inpEdit.value = text;
      inpEdit.selectionStart = text.length;
    }
  }

  void _onEditKeyboardInput(e) {
    switch(e.keyCode) {
      case KeyCode.ENTER: {
        final editDTO = EditDTO(dom.id, inpEdit.value!.trim(), '');
        Wire.send(ViewSignals.EDIT, payload: editDTO);
      } break;
      case KeyCode.ESC: {
        _onEditCancel();
      } break;
    }
  }

  void _onDelete(e) {
    Wire.send(ViewSignals.DELETE, payload: this.id);
  }

  void _onToggle(e) {
    Wire.send(ViewSignals.TOGGLE, payload: this.id);
  }

  void _onTodoDataChanged(dynamic todoVO) {
    todoVO != null ? update(todoVO as TodoVO) : remove();
  }

  void _onEditBegin() {
    dom.classes.add('editing');
    inpEdit.focus();
  }

  void _onEditCancel() {
    inpEdit.text = lblContent.text;
    dom.classes.remove('editing');
  }
}
