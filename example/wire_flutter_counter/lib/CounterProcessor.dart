import 'package:wire/wire.dart';

import 'const/CounterDataKey.dart';
import 'const/CounterSignals.dart';

class CounterController {
  CounterController() {
    Wire.add(this, CounterSignal.INCREASE, (data, wid) async {
      print('> Processor: INCREASE -> handle: ' + data.toString());
      Wire.data(CounterDataKey.COUNT, value: (value) {
        return value + 1;
      });
    });

    Wire.add(this, CounterSignal.DECREASE, (data, wid) async {
      print('> Processor: DECREASE -> handle: ' + data.toString());
      Wire.data(CounterDataKey.COUNT,
          value: (value) => value > 0 ? value - 1 : 0);
    });

    print('Processor Ready');
  }
}
