// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import 'package:wire_example_shared/todo/data/dto/EditDTO.dart';
import 'package:wire_example_shared/todo/data/dto/InputDTO.dart';
import 'package:wire_example_shared/todo/data/vo/TodoVO.dart';
import 'package:wire_flutter/wire_flutter.dart';
import 'package:wire_flutter_todo/flutter/const/ArchSampleKeys.dart';

class AddEditScreen extends StatefulWidget {
  final String? id;

  AddEditScreen({
    this.id,
  }) : super(key: ArchSampleKeys.addTodoScreen);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _text = '';
  String _note = '';

  @override
  Widget build(BuildContext context) {
    print('isEditing $isEditing');
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Todo" : "Add Todo"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          onWillPop: () {
            return Future(() => true);
          },
          child: !isEditing
              ? buildListViewWidget(context, null)
              : WireDataBuilder<TodoVO>(
                  dataKey: widget.id!,
                  builder: (ctx, todoVO) => buildListViewWidget(ctx, todoVO),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          key: isEditing ? ArchSampleKeys.saveTodoFab : ArchSampleKeys.saveNewTodo,
          tooltip: isEditing ? 'Save Changes' : 'Add Todo',
          child: Icon(isEditing ? Icons.check : Icons.add),
          onPressed: () {
            final form = formKey.currentState;
            if (form!.validate()) {
              form.save();

              if (isEditing) {
                Wire.send(ViewSignals.EDIT, payload: EditDTO(widget.id!, _text, _note));
              } else {
                Wire.send(ViewSignals.INPUT, payload: InputDTO(_text, _note));
              }

              Navigator.pop(context);
            }
          }),
    );
  }

  Widget buildListViewWidget(context, todoVO) => ListView(
        children: [
          TextFormField(
            initialValue: todoVO?.text ?? '',
            key: ArchSampleKeys.taskField,
            autofocus: isEditing ? false : true,
            style: Theme.of(context).textTheme.headline6,
            decoration: InputDecoration(hintText: 'New Todo'),
            validator: (val) => val!.trim().isEmpty ? 'Empty Todo' : null,
            onSaved: (value) => _text = value!,
          ),
          TextFormField(
            initialValue: todoVO?.note ?? '',
            key: ArchSampleKeys.noteField,
            maxLines: 10,
            style: Theme.of(context).textTheme.subtitle1,
            decoration: InputDecoration(
              hintText: 'Notes',
            ),
            onSaved: (value) => _note = value!,
          )
        ],
      );

  bool get isEditing => widget.id != null;
}
