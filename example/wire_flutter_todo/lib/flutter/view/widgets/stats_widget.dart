// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_flutter/wire_flutter.dart';
import 'package:wire_flutter_todo/flutter/const/ArchSampleKeys.dart';

class Stats extends StatelessWidget {
  Stats() : super(key: ArchSampleKeys.statsCounter);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WireDataBuilder<int>(
        dataKey: DataKeys.COUNT,
        builder: (context, notCompletedCount) {
          var allTodoCount = Wire.data(DataKeys.LIST_OF_IDS).value.length;
          var numCompleted = allTodoCount - notCompletedCount;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Completed Todos',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  '$numCompleted',
                  key: ArchSampleKeys.statsNumCompleted,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Active Todos',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  '$notCompletedCount',
                  key: ArchSampleKeys.statsNumActive,
                  style: Theme.of(context).textTheme.headline2,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
