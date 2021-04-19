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

  TodoListItemView(String id) : super(LIElement()) {
    listeners.addAll([
      inpToggle.onClick
          .listen((e) => Wire.send(ViewSignals.TOGGLE, payload: id)),
      btnDelete.onClick
          .listen((e) => Wire.send(ViewSignals.DELETE, payload: id)),
      inpEdit.onKeyDown.listen((e) {
        if (e.keyCode == KeyCode.ENTER) {
          Wire.send(ViewSignals.EDIT, payload: getEditData());
        } else if (e.keyCode == KeyCode.ESC) _OnEditCancel();
      }),
      lblContent.onDoubleClick.listen((_) => _OnEditBegin()),
      inpEdit.onBlur.listen((_) => _OnEditCancel())
    ]);

    var todoWireData = Wire.data(id);
    todoWireData.subscribe(_OnTodoDataChanged);
    if (todoWireData.isSet) _OnTodoDataChanged(todoWireData.value);

    container.append(inpToggle);
    container.append(lblContent);
    container.append(btnDelete);

    dom.append(inpEdit);
    dom.append(container);
  }

  void remove() {
    Wire.data(dom.id).unsubscribe(_OnTodoDataChanged);
    listeners.removeWhere((element) {
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

  EditDTO getEditData() => EditDTO(dom.id, inpEdit.value!.trim(), '');

  void _OnTodoDataChanged(dynamic todoVO) =>
      todoVO != null ? update(todoVO as TodoVO) : remove();

  void _OnEditBegin() {
    dom.classes.add('editing');
    inpEdit.focus();
  }

  void _OnEditCancel() {
    inpEdit.text = lblContent.text;
    dom.classes.remove('editing');
  }
}
