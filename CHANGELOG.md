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
