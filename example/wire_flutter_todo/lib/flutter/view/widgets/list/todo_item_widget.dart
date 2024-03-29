// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';
import 'package:wire_flutter/wire_flutter.dart';
import 'package:wire_flutter_todo/flutter/const/ArchSampleKeys.dart';

class TodoItem extends StatelessWidget {
  final String id;
  final GestureTapCallback onTap;
  final ValueChanged<bool?>? onToggle;

  TodoItem({
    Key? key,
    required this.id,
    required this.onTap,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WireDataBuilder<TodoVO>(
      dataKey: id,
      builder: (context, todoVO) => Visibility(
        visible: todoVO.visible,
        child: ListTile(
          onTap: onTap,
          leading: Checkbox(
            key: ArchSampleKeys.todoItemCheckbox(todoVO.id),
            value: todoVO.completed,
            onChanged: onToggle,
          ),
          title: Text(
            todoVO.text,
            key: ArchSampleKeys.todoItemTask(todoVO.id),
            style: Theme.of(context).textTheme.headline6,
          ),
          subtitle: Text(
            todoVO.note,
            key: ArchSampleKeys.todoItemNote(todoVO.id),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }
}
