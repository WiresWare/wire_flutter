## 1.3.2:
- Dependencies update: Wire library version 1.5.4 
- Examples checked for run and updated as well to wire 1.5.4

## 1.3.1:
- New WireDataBuilder constructor property WireDataWidgetNullBuilder? nullBuilder
- Utility mixin MixinWithWireData moved to Wire library and removed from repo

## 1.3.0:
- Utility mixin MixinWithWireData with shortcuts:
  - `has/hasNot(String dataKey)` - check for existence of `dataKey` in Wire.data,
  - `Future<T> get<T>(String dataKey)` - return value of `dataKey` or throw an error (handled from Future.onError), 
  - `Future<Map<String, dynamic>> getMany` - return list of values or throw an error in case of is absent,
  - `void update(String dataKey, { dynamic data, bool refresh = true })` - update `Wire.data`
  - `void reset(String dataKey)` - same as `Wire.data(dataKey).reset`
- Wire updated to 1.4.7 (with new method `Wire.addMany`)  

## 1.2.9:
- WireDataBuilder optional property isStatic which skip subscription to he Wire.data(dataKey) and only build component once.

## 1.2.8:
- Wire updated to min 1.4.5.

## 1.2.7:
- Wire updated to min 1.4.4.

## 1.2.6:
- Corrections: cast to possible dynamic value in build -> widget.build method replaced with strict T.

## 1.2.5
- Specify type of builder function parameter of WireDataWidgetBuilder<T> in WireDataBuilder

## 1.2.4
- Optional parameter `rebuildWhen` which determine if setState is triggered on new value therefore rebuild will happen or not

## 1.2.3
- WireDataBuilder simplified, inner reference to value removed
- _onWireData setState even when value is null

## 1.2.2
- Fix of "setstate() called after dispose()"
- Todo example with use of WireDataLockToken

## 1.2.1
- Wire lib updated to 1.4.2
- Mobile Todo example update with use of Hive database inside _shared code
- All examples updated to use async TodoModel constructor
- Working version of all 3 examples

## 1.2.0
- Wire lib updated to 1.4.0 with async and WireData getters

## 1.1.0
- Wire lib updated to 1.2.0 with null-safety

## 1.0.0
- Stable release
- Wire updated to 1.0.2
- README updated

## 0.9.4 (wire release version 1.0.0)
- Update to release version of Wire
- WireDataBuilder with types <T>
- Guarder dispose on empty value (when WireData was not set before requested from widget, then it must be removed)

## 0.9.1 (todo example - shared code)
- Working example of using different UI - Flutter (mobile and web) and custom HTML/JS in Todo example. Special scripts provided to build for all three examples - open Flutter project from folder `example/wire_flutter_todo`.

## 0.9.0
- Changes in example according changes in version 0.9.7 of Wire.
- Renaming to match library concepts - `dataKey` replaced `param` in `Wire.data`
- Internal library changes, no impact on how it used. Keep `dataKey` string constant instead of `WireData` instance in the StatefulWidget, use it in the `initState` function to retrieve value and subscribe to updates, later unsubscribe with this `dataKey`.

## 0.1.3
- Update to much Wire version 0.9.1 where WireDataListener lost its first param - scope

## 0.1.2
- README and TodoMVC example updated with gif of how example works

## 0.1.1
- WireData value stored in StatefulWidget State to keep it from become null on destroy of WireData object, nullify it on destroy of the component
- Update TodoMVC example to match changes, also fixes.

## 0.1.0
- Minor release, reference to WireData wireData as StatefulWidget parameter retrieved in construction
- TodoMVC example from flutter_architecture_samples using same shared business logic as in Wire HTML TodoMVC example
- Wire version updated to 0.5.0 (pre-release)
- Readme update

## 0.0.2
- Guard widget access on destroy because it might cause run-time error

## 0.0.1
- WireDataBuilder widget - (String param, Builder builder) - rebuild widget in builder when param changed 
