import 'package:wire/wire.dart';

import 'const/counter_params.dart';
import 'const/counter_signals.dart';

class CounterProcessor {
  CounterProcessor() {
    Wire.add(this, CounterSignal.INCREASE, (wire, data) {
      print('> Processor: INCREASE -> handle: ' + data.toString());
      Wire.data(CounterParams.COUNT, (value) {
        return value + 1;
      });
    });

    Wire.add(this, CounterSignal.DECREASE, (wire, data) {
      print('> Processor: DECREASE -> handle: ' + data.toString());
      Wire.data(CounterParams.COUNT, (value) {
        return value > 0 ? value - 1 : 0;
      });
    });

    print('Processor Ready');
  }
}