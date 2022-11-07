// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_flutter/wire_flutter.dart';
import 'package:wire_flutter_todo/flutter/const/ArchSampleKeys.dart';
import 'package:wire_flutter_todo/flutter/const/Routes.dart';
import 'package:wire_flutter_todo/flutter/enum/AppTab.dart';
import 'package:wire_flutter_todo/flutter/enum/ExtraAction.dart';
import 'package:wire_flutter_todo/flutter/view/widgets/buttons/extra_actions_button.dart';
import 'package:wire_flutter_todo/flutter/view/widgets/buttons/filter_button.dart';
import 'package:wire_flutter_todo/flutter/view/widgets/list/todo_list_widget.dart';
import 'package:wire_flutter_todo/flutter/view/widgets/stats_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super(key: ArchSampleKeys.homeScreen);
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  AppTab activeTab = AppTab.todos;

  void _updateTab(AppTab tab) {
    setState(() {
      activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo Wire App'),
          actions: [
            FilterButton(
              isActive: activeTab == AppTab.todos,
              activeFilter: FilterValues.ALL,
              onSelected: (filter) => Wire.send(ViewSignals.FILTER, payload: filter),
            ),
            WireDataBuilder<int>(
              dataKey: DataKeys.COUNT,
              builder: (context, notCompletedCount) {
                var allTodoCount = Wire.data(DataKeys.LIST_OF_IDS).value.length;
                var allCompleted = notCompletedCount == 0 && allTodoCount > 0;
                var hasCompletedTodos = (allTodoCount - notCompletedCount) > 0;
                return ExtraActionsButton(
                  allComplete: allCompleted,
                  hasCompletedTodos: hasCompletedTodos,
                  onSelected: (action) {
                    print('> ExtraActionsButton -> action: $action');
                    if (action == ExtraAction.toggleAllComplete) {
                      Wire.send(ViewSignals.COMPLETE_ALL, payload: !allCompleted);
                    } else if (action == ExtraAction.clearCompleted) {
                      Wire.send(ViewSignals.CLEAR_COMPLETED);
                    }
                  },
                );
              },
            )
          ],
        ),
        body: activeTab == AppTab.todos ? TodoList() : Stats(),
        floatingActionButton: FloatingActionButton(
          key: ArchSampleKeys.addTodoFab,
          onPressed: () => Navigator.pushNamed(context, TodoRoutes.addTodo),
          child: Icon(Icons.add),
          tooltip: 'Add Todo',
        ),
        bottomNavigationBar: createBottomNavigationWidget(activeTab));
  }

  Widget createBottomNavigationWidget(activeTab) => BottomNavigationBar(
        key: ArchSampleKeys.tabs,
        currentIndex: AppTab.values.indexOf(activeTab),
        onTap: (index) {
          _updateTab(AppTab.values[index]);
        },
        items: AppTab.values.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(
              tab == AppTab.todos ? Icons.list : Icons.show_chart,
              key: tab == AppTab.stats ? ArchSampleKeys.statsTab : ArchSampleKeys.todoTab,
            ),
            label: tab == AppTab.stats ? 'Stats' : 'Todos',
          );
        }).toList(),
      );
}
