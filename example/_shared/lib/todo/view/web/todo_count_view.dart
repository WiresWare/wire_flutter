import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class TodoCountView extends DomElement {
  TodoCountView(super.dom) {
    final wdCount = Wire.data(DataKeys.COUNT);
    final wdCompletedCount = Wire.data(DataKeys.GET_COUNT_COMPLETED);

    wdCount.subscribe((value) async {
      await _updateCount(value, wdCompletedCount.value);
    });
    _updateCount(wdCount.value, wdCompletedCount.value);
  }

  Future<void> _updateCount(int count, int completedCount) async {
    dom.textContent = '${count} | ${completedCount}';
  }
}
