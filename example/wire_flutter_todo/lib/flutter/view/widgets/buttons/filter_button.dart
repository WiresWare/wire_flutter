// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';
import 'package:wire_flutter_todo/flutter/const/ArchSampleKeys.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<FilterValues> onSelected;
  final FilterValues activeFilter;
  final bool isActive;

  FilterButton({required this.onSelected, required this.activeFilter, required this.isActive, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).secondaryHeaderColor);
    final activeStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor);
    final button = _Button(
      onSelected: onSelected,
      activeFilter: activeFilter,
      activeStyle: activeStyle,
      defaultStyle: defaultStyle!,
    );

    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: isActive ? button : IgnorePointer(child: button),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.onSelected,
    required this.activeFilter,
    required this.activeStyle,
    required this.defaultStyle,
  }) : super(key: key);

  final PopupMenuItemSelected<FilterValues> onSelected;
  final FilterValues activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FilterValues>(
      key: ArchSampleKeys.filterButton,
      tooltip: 'Filter Todos',
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<FilterValues>>[
        PopupMenuItem<FilterValues>(
          key: ArchSampleKeys.allFilter,
          value: FilterValues.ALL,
          child: Text(
            'Show All',
            style: activeFilter == FilterValues.ALL ? activeStyle : defaultStyle,
          ),
        ),
        PopupMenuItem<FilterValues>(
          key: ArchSampleKeys.activeFilter,
          value: FilterValues.ACTIVE,
          child: Text(
            'Show Active',
            style: activeFilter == FilterValues.ACTIVE ? activeStyle : defaultStyle,
          ),
        ),
        PopupMenuItem<FilterValues>(
          key: ArchSampleKeys.completedFilter,
          value: FilterValues.COMPLETED,
          child: Text(
            'Show Completed',
            style: activeFilter == FilterValues.COMPLETED ? activeStyle : defaultStyle,
          ),
        ),
      ],
      icon: Icon(Icons.filter_list),
    );
  }
}
