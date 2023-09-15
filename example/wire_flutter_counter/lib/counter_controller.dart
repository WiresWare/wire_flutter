import 'package:wire/wire.dart';

import 'const/CounterDataKey.dart';
import 'const/CounterSignals.dart';

class CounterController {
  CounterController() {
    Wire.add(this, CounterSignal.INCREASE, (_, wid) async {
      // print('> Processor: INCREASE -> handle: ' + _.toString());
      Wire.data(CounterDataKey.COUNT, value: (prev) {
        return prev + 1;
      });
    });

    Wire.add(this, CounterSignal.DECREASE, (_, wid) async {
      // print('> Processor: DECREASE -> handle: ' + _.toString());
      Wire.data(CounterDataKey.COUNT, value: (prev) {
        return prev > 0 ? prev - 1 : 0;
      });
    });

    print('Processor Ready');
  }
}
