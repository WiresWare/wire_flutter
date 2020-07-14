# wire_flutter

Wire for Flutter widget - WireDataBuilder
See Wire: https://pub.dev/packages/wire

## Getting Started
See examples

You need update on data change:
```dart
WireDataBuilder<int>(
  param: CounterParams.COUNT,
  builder: (context, value) => Text(
      '$value',
      style: Theme.of(context).textTheme.headline4,
    )
)
```
Initiate change with firing signal:
```dart
FloatingActionButton(
  onPressed: () => Wire.send(CounterSignal.INCREASE),
  child: Icon(Icons.add),
)
```
React on signal and update data (even passing function to data value). The new value or function call result will be propagated to the WireData listener, and build in WireDataBuilder will rebuild widget with already new value.
```dart
Wire.add(this, CounterSignal.INCREASE, (signal, data) {
  Wire.data(CounterParams.COUNT, (value) {
    return value + 1;
  });
});
```

