import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/data/dto/edit_dto.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';
import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class TodoListItemView extends DomElement {
  TodoListItemView(String id) : super(document.createElement('li') as HTMLLIElement) {
    dom.id = id;

    inpToggle.addEventListener('click', (event) {
      Wire.send(ViewSignals.TOGGLE, payload: id);
    }.toJS);
    btnDelete.addEventListener('click', (event) {
      Wire.send(ViewSignals.DELETE, payload: id);
    }.toJS);
    inpEdit.addEventListener('keydown', (Event event) {
      final e = event as KeyboardEvent;
      if (e.key == 'Enter') {
        Wire.send(ViewSignals.EDIT, payload: getEditData());
      } else if (e.key == 'Escape') {
        _OnEditCancel();
      }
    }.toJS);
    lblContent.addEventListener('dblclick', (event) {
      _OnEditBegin();
    }.toJS);
    inpEdit.addEventListener('blur', (event) {
      _OnEditCancel();
    }.toJS);

    final wdTodo = Wire.data(id);
    wdTodo.subscribe(_OnDataChanged);

    container.append(inpToggle);
    container.append(lblContent);
    container.append(btnDelete);

    dom.append(inpEdit);
    dom.append(container);

    if (wdTodo.isSet) _OnDataChanged(wdTodo.value);
  }

  final inpToggle = (document.createElement('input') as HTMLInputElement)
    ..className = 'toggle'
    ..type = 'checkbox';

  final lblContent = document.createElement('label') as HTMLLabelElement..className = 'todo-content';
  final btnDelete = document.createElement('button') as HTMLButtonElement..className = 'destroy';
  final inpEdit = (document.createElement('input') as HTMLInputElement)..className = 'edit';
  final container = document.createElement('div') as HTMLDivElement..className = 'view';

  void remove() {
    final wdTodo = Wire.data(dom.id);
    final hasListener = wdTodo.hasListener(_OnDataChanged);
    if (hasListener) wdTodo.unsubscribe(listener: _OnDataChanged, immediate: true);
    container.remove();
    inpEdit.remove();
    dom.remove();
  }


  void update(TodoVO todoVO) {
    dom.id = todoVO.id;
    dom.style.display = todoVO.visible ? 'block' : 'none';

    if (todoVO.visible) {
      final text = htmlEscape.convert(todoVO.text);
      dom.className = todoVO.completed ? 'completed' : '';
      inpToggle.checked = todoVO.completed;
      lblContent.textContent = text;
      inpEdit.value = text;
      inpEdit.selectionStart = text.length;
    }
  }

  EditDTO getEditData() => EditDTO(dom.id, inpEdit.value.trim(), '');

  Future<void> _OnDataChanged(dynamic input) async {
    final todoVO = input as TodoVO?;
    print('> TodoListItemView -> _OnTodoDataChanged = ${todoVO?.id ?? 'empty'}');
    if (todoVO == null) {
      remove();
    } else {
      update(todoVO);
    }
  }

  void _OnEditBegin() {
    dom.classList.add('editing');
    inpEdit.focus();
  }

  void _OnEditCancel() {
    inpEdit.textContent = lblContent.textContent;
    dom.classList.remove('editing');
  }
}
