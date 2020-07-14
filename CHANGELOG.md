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
