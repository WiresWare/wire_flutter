# wire_flutter

Wire for Flutter widget - WireDataBuilder
See Wire: https://pub.dev/packages/wire

## Getting Started
See examples

You need update on data change:
```
WireDataBuilder<int>(
  param: CounterParams.COUNT,
  builder: (context, value) => Text(
      '$value',
      style: Theme.of(context).textTheme.headline4,
    )
)
```
Initiate change with firing signal:
```
FloatingActionButton(
  onPressed: () => Wire.send(CounterSignal.INCREASE),
  child: Icon(Icons.add),
)
```
React on signal and update data (even passing function to data value):
```
Wire.add(this, CounterSignal.INCREASE, (signal, data) {
  Wire.data(CounterParams.COUNT, (value) {
    return value + 1;
  });
});
```

