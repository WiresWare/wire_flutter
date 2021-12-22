// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'package:wire_flutter_todo/flutter/const/ArchSampleKeys.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import 'package:wire_example_shared/todo/const/ApplicationState.dart';
import 'package:wire_example_shared/todo/data/dto/InputDTO.dart';
import 'package:wire_example_shared/todo/data/vo/TodoVO.dart';
import 'package:wire_flutter_todo/flutter/view/screens/detail_screen.dart';
import 'package:wire_flutter_todo/flutter/view/widgets/list/todo_item_widget.dart';
import 'package:wire/wire.dart';
import 'package:wire_flutter/wire_flutter.dart';

class TodoList extends StatelessWidget {
  TodoList() : super(key: ArchSampleKeys.todoList);

  @override
  Widget build(BuildContext context) {
    return WireDataBuilder<TodoApplicationState>(
      dataKey: DataKeys.STATE,
      builder: (context, state) => Container(
        child: state == TodoApplicationState.LOADING
            ? Center(
                child: CircularProgressIndicator(
                key: ArchSampleKeys.todosLoading,
              ))
            : WireDataBuilder<List<String>>(
                dataKey: DataKeys.LIST_OF_IDS,
                builder: (context, list) => ListView.builder(
                  key: ArchSampleKeys.todoList,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todoId = list[index];
                    return Dismissible(
                      key: ArchSampleKeys.todoItem(todoId),
                      onDismissed: (direction) {
                        _removeTodo(context, todoId);
                      },
                      child: TodoItem(
                        id: todoId,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(id: todoId,
                                onDelete: () => { _removeTodo(context, todoId) },
                              ),
                            ),
                          );
                        },
                        onToggle: (value) {
                          print('> TodoItem click $todoId');
                          Wire.send(ViewSignals.TOGGLE, payload: todoId);
                        }),
                    );
                  },
                ),
              ),
      ),
    );
  }

  void _removeTodo(BuildContext context, String todoId) {
    var todoWireData = Wire.data(todoId);
    TodoVO todoVO = todoWireData.value;
    Wire.send(ViewSignals.DELETE, payload: todoId);

    Scaffold.of(context).showSnackBar(
      SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: Duration(seconds: 3),
        content: Text(
          'Delete Todo: ${todoVO.text}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () => Wire.send(ViewSignals.INPUT,
                payload: InputDTO(todoVO.text, todoVO.note, todoVO.completed))),
      ),
    );
  }
}
